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
TESTING_PACKAGE = os.environ.get("TESTING_PACKAGE")

MPR_URL = "mpr.makedeb.org"
PROGET_URL = "proget.hunterwittenborn.com"
MPR_ARCHIVE_URL = f"https://{MPR_URL}/packages-meta-ext-v2.json.gz"
GITHUB_REPO = "makedeb/prebuilt-mpr-v2"
GITHUB_REPO_URL = f"https://{GITHUB_USERNAME}:{GITHUB_PAT}@github.com/{GITHUB_REPO}"
GIT_REPO_PATH = "/prebuilt-mpr"

TEMPLATE_DIRECTORY = "/usr/local/share/prebuilt-mpr/templates/packages"

with open("/usr/local/share/prebuilt-mpr/packages.txt") as file:
    PKGLIST = file.read().splitlines()

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
        pkgver = None
        pkgrel = None
        epoch = None
        srcinfo = run_command(["git", "show", f"origin/pkg/{pkgname}:pkg/.SRCINFO"]).stdout.decode()

        for line in srcinfo.splitlines():
            parts = line.replace("\t", "").split(" = ")
            key = parts[0]
            value = " = ".join(parts[1:])

            if key == "pkgver":
                pkgver = value
            elif key == "pkgrel":
                pkgrel = value
            elif key == "epoch":
                epoch = value

        if epoch is not None:
            return f"{epoch}:{pkgver}-{pkgrel}"
        else:
            return f"{pkgver}-{pkgrel}"

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
    mpr_packages = []

    _mpr_packages = requests.get(MPR_ARCHIVE_URL).json()

    for pkg in _mpr_packages:
        if pkg["Name"] in PKGLIST:
            mpr_packages += [pkg]

    # If TESTING_PACKAGE is not None, use that.
    # We use it during local development testing.
    if TESTING_PACKAGE is not None:
        testpkg_pkgname, testpkg_pkgver = TESTING_PACKAGE.split("/")
        mpr_packages = [{"Name": testpkg_pkgname, "Version": testpkg_pkgver}]

    # Make sure the Git repository is up to date.
    logger.info("Making sure Prebuilt-MPR Git repository is up to date...")
    run_command(["git", "checkout", "main"])
    run_command(["git", "fetch", "origin"])
    run_command(["git", "pull", "--all"])

    # Delete all local copies of a branch in case they're out of date from
    # pushes created by external sources.
    logger.info("Purging local package branches...")
    local_pkg_branches = (
        run_command(["git", "branch", "--list", "pkg/*"])
        .stdout.decode()
        .splitlines()
    )

    local_pkg_branches += (
        run_command(["git", "branch", "--list", "pkg-update/*"])
        .stdout.decode()
        .splitlines()
    )

    local_pkg_branches = [branch.lstrip("* ") for branch in local_pkg_branches]

    for branch in local_pkg_branches:
        run_command(["git", "branch", "-D", branch])

    # 'git branch' doesn't format things nicely to be processed here, so we use 'for-each-ref' instead.
    remote_git_branches = (
        run_command(["git", "for-each-ref", "--format=%(refname:short)", "refs/remotes/origin/"])
        .stdout.decode()
        .splitlines()
    )

    # Remove the 'origin/' prefix on the branches.
    remote_git_branches = [branch.replace("origin/", "") for branch in remote_git_branches]

    for pkg in mpr_packages:
        check_for_interrupt()
        # Run the entire code block in a 'try-except' block so that we can process the next package if an error pops up.
        try:
            pkgname = pkg["Name"]
            version = pkg["Version"]
            tag_version = version.replace(":", "!")
            target_branch_name = f"pkg/{pkgname}"
            pr_branch_name = f"pkg-update/{pkgname}"

            logger.info(f"Checking %s for updates..." % repr(pkgname))
        
            # If the Git branch doesn't exist, initialize it and push it to the origin.
            if target_branch_name not in remote_git_branches:
                run_command(["git", "switch", "--orphan", target_branch_name])

                # Add template files.
                shutil.copytree(TEMPLATE_DIRECTORY, "./", dirs_exist_ok=True)
                run_command(["git", "add", "."])
                run_command(["git", "commit", "-m", "Initial commit [CI SKIP]"])
                run_command(["git", "push", "--set-upstream", "origin", target_branch_name])
            else:
                run_command(["git", "checkout", target_branch_name])

            # If the Git branch for package updates doesn't exist, initialize it.
            #
            # It's important that this is done from the 'pkg/{pkgname}' branch
            # from the previous step, as we need a similar Git history in order
            # for PRs to work properly.
            if pr_branch_name not in remote_git_branches:
                run_command(["git", "branch", pr_branch_name])
        
            run_command(["git", "checkout", pr_branch_name])

            # First merge the 'pkg/' branch into this branch in case there's been updates to it.
            #
            # This would need to happen if both 'pkg/' and 'pkg-update/' exist, and pushes
            # to 'pkg/' have been done outside of this script, but not to 'pkg-update/'
            # (such is the case when running 'scripts/update-templates.sh').
            run_command(["git", "merge", target_branch_name])

            # If 'pkg/' exists, delete it.
            if os.path.exists("pkg/"):
                shutil.rmtree("pkg/")
        
            # Clone the files from the MPR into the Git repository.
            mpr_dir = tempfile.TemporaryDirectory()
            run_command(["git", "clone", f"https://mpr.makedeb.org/{pkgname}", "-b", f"ver/{tag_version}", mpr_dir.name])
            shutil.rmtree(f"{mpr_dir.name}/.git")
            shutil.copytree(mpr_dir.name, "./pkg")
            shutil.rmtree(mpr_dir.name)

            # Add new packaging files.
            commit_message = f"pkg-update: {pkgname}"
            run_command(["git", "add", "pkg/"])

            # If there's a diff, commit.
            if run_command(["git", "diff", "--staged", "--name-only", "pkg/"]).stdout.decode() != "":
                run_command(["git", "commit", "-m", commit_message])
            
            # If 'pkg-update/' didn't exist in the origin, or we have some new commits compared to the upstream, push the changes.
            if (
                    pr_branch_name not in remote_git_branches
                    or (
                        run_command(["git", "log", f"{pr_branch_name}...origin/{pr_branch_name}", "--oneline"])
                        .stdout.decode()
                        .splitlines()
                    ) != []
            ):
                run_command(["git", "push", "--set-upstream", "origin", pr_branch_name])

            # If no PR is open for this package and there's a diff between the 'pkg/{pkgname}' and 'pkg-update/{pkg}' branches, create it.
            try:
                pr_titles = [pull.title for pull in repo.pull_requests()]
                git_diff = run_command(["git", "diff", target_branch_name, pr_branch_name]).stdout.decode()
                new_changes = run_command(["git", "diff", pr_branch_name, target_branch_name]).stdout.decode() != ""
                if new_changes and commit_message not in pr_titles:
                    repo.create_pull(commit_message, target_branch_name, pr_branch_name, maintainer_can_modify=True)
                    # Sleep a few seconds so we don't spam the GitHub API really quickly.
                    time.sleep(5)

            # If we get a ForbiddenError, we've probably encountered a
            # secondary rate limit and need to wait a bit
            # before making another request.
            except github3.exceptions.ForbiddenError as exc:
                    logger.error("Encountered a rate limit. Waiting five minutes before processing more requests...")
                    time.sleep(60*5) # Five minutes.

        except Exception as exc:
            logger.error(f"Got exception. Restoring Git repository to origin's state and continuing loop.")
            logger.error(traceback.format_exc())
            run_command(["git", "fetch", "origin"])
            run_command(["git", "checkout", "main"])
            run_command(["git", "reset", "--hard", "origin/main"])


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
