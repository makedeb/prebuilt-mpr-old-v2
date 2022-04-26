#!/usr/bin/env python3
import requests
import io
import logging
import os
import pathlib
import json
import subprocess
import tempfile
import time
import signal
import shutil
import traceback
import textwrap
import html

import apt_pkg
import github3

# Set up logging.
logger = logging.getLogger("prebuilt-mpr")
logger.setLevel(logging.INFO)
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
formatter = logging.Formatter("%(levelname)s: %(message)s")
ch.setFormatter(formatter)
logger.addHandler(ch)

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
        logger.error(f"Missing environment variable {var}.")
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

TEMPLATE_DIRECTORY = "/usr/local/share/prebuilt-mpr/templates/packages"

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
        return run_command(["git", "show", f"origin/pkg/{pkgname}:version.txt"]).stdout.decode()
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
        logger.info("Recieved interrupt. No longer processing queues.")
        exit()


# Set up Git.
logger.debug("Configuring Git...")
run_command(["git", "config", "--global", "user.name", GIT_NAME])
run_command(["git", "config", "--global", "user.email", GIT_EMAIL])

# Clone the Git directory.
logger.info("Cloning Prebuilt-MPR Git repository...")
run_command(["git", "clone", GITHUB_REPO_URL, GIT_REPO_PATH])
os.chdir(GIT_REPO_PATH)

# Initialize the Python APT library.
logger.debug("Initializing Python APT library...")
apt_pkg.init()

# Declare main.
def main():
    check_for_interrupt()

    # Fetch current archive from MPR.
    logger.info("Fetching MPR package list...")
    mpr_packages = requests.get(MPR_ARCHIVE_URL).json()

    # Check for packages that need to be updated.
    ood_packages = []

    for pkg in mpr_packages:
        pkgname = pkg["Name"]
        mpr_version = pkg["Version"]

        prebuilt_mpr_version = get_prebuilt_mpr_version(pkgname)

        # If a version couldn't be found, that means the package hasen't been added,
        # and we need to run a CI pipeline for it.
        if prebuilt_mpr_version is None:
            ood_packages += [pkgname]
        elif apt_pkg.version_compare(prebuilt_mpr_version, mpr_version) < 0:
            ood_packages += [pkgname]
    
    # Make sure the Git repository is up to date.
    logger.info("Making sure Prebuilt-MPR Git repository is up to date...")
    run_command(["git", "fetch", "origin"])
    run_command(["git", "pull", "--all"])

    # For each package that's out of date, create a PR on GitHub.
    if len(ood_packages) != 0:
        logger.info(f"Found {len(ood_packages)} out of date packages. Updating packages...")

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
        logger.info(f"Updating {pkgname}...")
        version = get_mpr_package(pkgname, mpr_packages)["Version"]
        tag_version = version.replace(":", "!")
        target_branch_name = f"pkg/{pkgname}"
        pr_branch_name = f"pkg-update/{pkgname}"
        
        # If the Git branch doesn't exist, initialize it and push it to the origin.
        if target_branch_name not in git_branches:
            run_command(["git", "switch", "--orphan", target_branch_name])

            # We have to have some kind of file in the repository for PRs to work,
            # as otherwise GitHub thinks the new empty branch will be a separate
            # Git history from that of any other branch.
            pathlib.Path(".gitignore").touch()
            run_command(["git", "add", ".gitignore"])

            run_command(["git", "commit", "-m", "Initial commit"])
            run_command(["git", "push", "--set-upstream", "origin", target_branch_name])
        else:
            run_command(["git", "checkout", target_branch_name])

        # If the Git branch for package updates doesn't exist, initialize it.
        #
        # It's important that this is done from the 'pkg/{pkgname}' branch
        # from the previous step, as we need a similar Git history in order
        # for PRs to work properly.
        if pr_branch_name not in git_branches:
            run_command(["git", "branch", pr_branch_name])
        
        run_command(["git", "checkout", pr_branch_name])

        # If 'pkg/' exists, delete it.
        if os.path.exists("pkg/"):
            shutil.rmtree("pkg/")
        
        # Clone the files from the MPR into the Git repository.
        mpr_dir = tempfile.TemporaryDirectory()
        run_command(["git", "clone", f"https://mpr.makedeb.org/{pkgname}", "-b", f"ver/{tag_version}", mpr_dir.name])
        shutil.rmtree(f"{mpr_dir.name}/.git")
        shutil.copytree(mpr_dir.name, "./pkg")
        shutil.rmtree(mpr_dir.name)

        # Set up needed files for the commit.
        commit_message = f"pkg-update: {pkgname}"
        shutil.copytree(TEMPLATE_DIRECTORY, "./", dirs_exist_ok=True)
        
        # Add files.
        run_command(["git", "add", "."])

        # If there's a diff, commit and push.
        if run_command(["git", "diff", "--cached", "--name-only"]).stdout.decode() != "":
            run_command(["git", "commit", "-m", commit_message])
            run_command(["git", "push", "--set-upstream", "origin", pr_branch_name])

        # If not PR is open for this package, create it.
        prs = [pull.title for pull in repo.pull_requests()]

        if commit_message not in prs:
            # If we get a ForbiddenError, we've probably encountered a
            # secondary rate limit and need to wait a bit
            # before making another request.
            try:
                repo.create_pull(commit_message, target_branch_name, pr_branch_name, maintainer_can_modify=True)
            except github3.exceptions.ForbiddenError as exc:
                logging.error("Encountered a rate limit. Waiting five minutes before processing more requests...")
                time.sleep(60*5) # Five minutes.

        # Sleep a few seconds so we don't spam the GitHub API really quickly.
        time.sleep(5)


# Start running main() on loop.
while True:
    try:
        logger.info("Beginning package check...")
        main()
        logger.info("Succesfully finished package checks.")
    except Exception:
        logger.error(f"Got exception. Restoring Git repository to origin's state and continuing loop.")
        logger.error(traceback.format_exc())
        run_command(["git", "fetch", "origin"])
        run_command(["git", "checkout", "main"])
        run_command(["git", "reset", "--hard", "origin/main"])
        continue
