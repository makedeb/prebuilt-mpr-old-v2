#!/usr/bin/env python3
import requests
import io
import logging
import os
import json
import subprocess
import tempfile
import time
import signal
import traceback

import apt_pkg
import github3

# Set up logging.
logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.INFO)

# Make sure needed environment variables are defined.
missing_var = False

needed_vars = [
    "GITHUB_PAT",
    "GITHUB_USERNAME",
    "GIT_NAME",
    "GIT_EMAIL"
]

for var in needed_vars:
    if var not in os.environ:
        logging.error(f"Missing environment variable {var}.")
        missing_var = True

if missing_var:
    exit(1)

# Handy variables.
GITHUB_PAT = os.environ["GITHUB_PAT"]
GITHUB_USERNAME = os.environ["GITHUB_USERNAME"]
GIT_NAME = os.environ["GIT_NAME"]
GIT_EMAIL = os.environ["GIT_EMAIL"]

MPR_URL = "mpr.makedeb.org"
PROGET_URL = "proget.hunterwittenborn.com"
MPR_ARCHIVE_URL = f"https://{MPR_URL}/packages-meta-ext-v2.json.gz"
GITHUB_REPO = "makedeb/prebuilt-mpr-v2"
GITHUB_REPO_URL = f"https://{GITHUB_USERNAME}:{GITHUB_PAT}@github.com/{GITHUB_REPO}"
GIT_REPO_PATH = "/prebuilt-mpr"

# Set up GitHub client.
owner, repo_name = GITHUB_REPO.split("/")
gh = github3.login(token=GITHUB_PAT)
repo = gh.repository(owner, repo_name)
del owner, repo_name

# Handy exceptions.
class BadExitCode(Exception):
    pass

# Handy functions.
def get_mpr_package(pkgname, mpr_packages):
    for pkg in mpr_packages:
        if pkg["Name"] == pkgname:
            return pkg

def run_command(*args, **kwargs):
    cmd = subprocess.run(*args, **kwargs, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if cmd.returncode != 0:
        raise BadExitCode(cmd.stderr.decode())
    
    return cmd

def get_prebuilt_mpr_version(pkgname):
    try:
        return json.loads(
            run_command(["git", "show", f"main:packages/{pkgname}"]).stdout.decode()
        )["version"]
    except BadExitCode:
        return None

# Ensure that we stop processing packages if we recieve a SIGINT or SIGTERM.
sig_interrupt = False

def terminate(signal_id, frame):
    global sig_interrupt
    sig_interrupt = True

signal.signal(signal.SIGTERM, terminate)
signal.signal(signal.SIGINT, terminate)

def check_for_interrupt():
    global sig_interrupt
    if sig_interrupt:
        logging.info("Recieved interrupt. No longer processing queues.")
        exit()


# Set up Git.
logging.debug("Configuring Git...")
run_command(["git", "config", "--global", "user.name", GIT_NAME])
run_command(["git", "config", "--global", "user.email", GIT_EMAIL])

# Clone the Git directory.
logging.info("Cloning Prebuilt-MPR Git repository...")
run_command(["git", "clone", GITHUB_REPO_URL, GIT_REPO_PATH])
os.chdir(GIT_REPO_PATH)

# Initialize the Python APT library.
logging.debug("Initializing Python APT library...")
apt_pkg.init()

# Declare main.
def main():
    check_for_interrupt()

    # Fetch current archive from MPR.
    logging.info("Fetching MPR package list...")
    mpr_packages = requests.get(MPR_ARCHIVE_URL).json()

    # Check for packages that need to be updated.
    ood_packages = []

    for pkg in mpr_packages:
        pkgname = pkg["Name"]
        mpr_version = pkg["Version"]

        prebuilt_mpr_version = get_prebuilt_mpr_version(pkgname)

        # If a version couldn't be found, that means the package hasen't been added, and we need to run a CI pipeline for it.
        if prebuilt_mpr_version is None:
            ood_packages += [pkgname]
        elif apt_pkg.version_compare(prebuilt_mpr_version, mpr_version) < 0:
            ood_packages += [pkgname]
    
    # Make sure we're checked out to the 'main' branch.

    # Make sure the Git repository is up to date.
    # Also make sure we're on 'main', as other branches might not have an
    # upstream yet if there's a bug somewhere in our code and one wasn't
    # yet created.
    logging.info("Making sure Prebuilt-MPR Git repository is up to date...")
    run_command(["git", "checkout", "main"])
    run_command(["git", "pull"])

    # For each package that's out of date, create a PR on GitHub.
    if len(ood_packages) != 0:
        logging.info(f"Found {len(ood_packages)} out of date packages. Updating packages...")

    # 'git branch' doesn't format things nicely to be processed here, so we use 'for-each-ref' instead.
    git_branches = (
        run_command(["git", "for-each-ref", "--format=%(refname:short)", "refs/remotes/origin/"])
        .stdout.decode()
        .splitlines()
    )

    # Remove the 'origin/' prefix on the branches.
    git_branches = [branch.replace("origin/", "") for branch in git_branches]

    for pkgname in ood_packages:
        check_for_interrupt()

        # Make sure we start from the 'main' branch, so things like new branches are based on that one.
        run_command(["git", "checkout", "main"])

        logging.info(f"Updating {pkgname}...")
        pkgver = get_mpr_package(pkgname, mpr_packages)["Version"]
        branch_name = f"pkg-update/{pkgname}"
        
        # Checkout the branch, creating if needed.
        if branch_name not in git_branches:
            run_command(["git", "branch", branch_name])
        
        run_command(["git", "checkout", branch_name])

        # Set up needed files for the commit.
        pkg_json = json.dumps({"version": pkgver}) + "\n"
        json_file = f"packages/{pkgname}"
        commit_message = f"pkg-update: {pkgname}"
        
        # If 'packages/' doesn't exist, create it.
        with open(json_file, "w") as file:
            file.write(pkg_json)
        
        # Add files.
        run_command(["git", "add", json_file])

        # If there's a diff, commit and push.
        if run_command(["git", "diff", "--cached", "--name-only"]).stdout.decode() != "":
            run_command(["git", "commit", "-m", commit_message])
            run_command(["git", "push", "--set-upstream", "origin", branch_name])

        # If not PR is open for this package, create it.
        prs = [pull.title for pull in repo.pull_requests()]

        if commit_message not in prs:
            repo.create_pull(commit_message, "main", branch_name, maintainer_can_modify=True)
            time.sleep(1) # Sleep so we don't slam the GitHub API with requests.

# Start running main() on loop.
while True:
    try:
        time.sleep(5)
        logging.info("Beginning package check...")
        main()
        logging.info("Succesfully finished package checks.")
    except Exception:
        logging.error(f"Got exception. Restoring Git repository to origin's state and continuing loop.")
        logging.error(traceback.format_exc())
        run_command(["git", "fetch", "origin"])
        run_command(["git", "checkout", "main"])
        run_command(["git", "reset", "--hard", "origin/main"])
        continue
