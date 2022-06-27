#!/usr/bin/env python3
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
distro_codename = os.environ["distro_codename"]
distros = os.environ.get("distros")
pkgname = branch.replace("pkg/", "")

# If we specified a list of distros to build on and the current distro isn't in that, skip the build.
if distros != None and distro_codename in distros.split(","):
    logging.info("Skipping build for %s..." % repr(distro_codename))
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
