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
pkgname = branch.replace("pkg/", "")
build_dir = f"/tmp/prebuilt-mpr/{pkgname}"

os.chdir(f"{build_dir}/pkg")

packages = []

for path in pathlib.Path("./").glob("*"):
    with apt_pkg.TagFile(f"{path.name}/DEBIAN/control") as tagfile:
        section = list(tagfile)[0]

        pkgname = section["Package"]
        version = section["Version"]
        version = re.sub("^[^:]*:", "", version)
        arch = section["Architecture"]

        packages += [f"{pkgname}_{version}_{arch}.deb"]

os.chdir(build_dir)

succesful_upload = True

for pkg in packages:
    logging.info(f"Uploading %s..." % repr(pkg))
    with open(pkg, "rb") as file:
        response = requests.post(
            f"https://proget.{hw_url}/debian-packages/upload/prebuilt-mpr-ubuntu/main/{pkg}",
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
