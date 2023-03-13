#!/usr/bin/env python3
import json
import os
import pathlib
import requests
import logging
import re

import apt_pkg

logging.basicConfig(format="%(levelname)s: %(message)s")
apt_pkg.init()

proget_api_key = os.environ["proget_api_key"]
hw_url = os.environ["hw_url"]
branch = os.environ["DRONE_BRANCH"]
build_number = os.environ["DRONE_BUILD_NUMBER"]
repo = os.environ["DRONE_REPO"]
distro_codename = os.environ["distro_codename"]
distros = os.environ.get("distros")
pkgname = branch.replace("pkg/", "")

# If the build for the current distribution is failed, abort.
response = requests.get(f"https://drone.{hw_url}/api/repos/{repo}/builds/{build_number}")

if response.status_code != 200:
    logging.error("Failed to fetch build status from Drone CI.")
    exit(1)

stages = json.loads(response.text)["stages"]

for stage in stages:
    if stage["name"] == f"{distro_codename}-build":
        # The second stage of a build, a.k.a. the 'build' step.
        if stage["steps"][1]["status"] != "success":
            logging.warning("Skipping publishing, as build stage for %s failed." % repr(distro_codename))
            exit()
        break

# If we specified a list of distros to build on and the current distro isn't in that, skip the build.
if distros != None and distro_codename not in distros.split(","):
    logging.warning("Skipping build for %s..." % repr(distro_codename))
    exit()

os.chdir(f"/mnt/prebuilt-mpr/{pkgname}/{distro_codename}/pkg")

packages = []

for path in pathlib.Path("./").glob("*"):
    with apt_pkg.TagFile(f"{path.name}/DEBIAN/control") as tagfile:
        section = list(tagfile)[0]

        pkgname = section["Package"]
        version = section["Version"]
        version = re.sub("^[^:]*:", "", version)
        arch = section["Architecture"]

        packages += [f"{pkgname}_{version}_{arch}.deb"]

os.chdir("../")

succesful_upload = True

for pkg in packages:
    logging.info(f"Uploading %s..." % repr(pkg))
    with open(pkg, "rb") as file:
        response = requests.post(
            f"https://proget.{hw_url}/debian-packages/upload/prebuilt-mpr/{distro_codename}/{pkg}",
            data=file,
            auth=requests.auth.HTTPBasicAuth("api", proget_api_key)
        )

        if response.reason != "Created":
            logging.error("Failed to upload package.")
            succesful_upload = False

if succesful_upload is False:
    exit(1)
else:
    exit(0)
