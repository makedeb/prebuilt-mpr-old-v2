#!/usr/bin/env python3
import json
import os
import requests
import logging

logging.basicConfig(format="%(levelname)s: %(message)s")

build_number = os.environ["DRONE_BUILD_NUMBER"]
repo = os.environ["DRONE_REPO"]
hw_url = os.environ["hw_url"]

# Make sure all steps succeeded. If they didn't mark the build as failed.
response = requests.get(f"https://drone.{hw_url}/api/repos/{repo}/builds/{build_number}")

if response.status_code != 200:
    logging.error("Failed to fetch build status from Drone CI.")
    exit(1)

stages = json.loads(response.text)["stages"]
success = True

for stage in stages:
    for step in stage["steps"]:
        if step["status"] not in ("success", "running"):
            logging.error(
                "Build failed on %s/%s." % (
                    step["name"],
                    stage["name"]
                )
            )
            success = False

if success is not True:
    exit(1)
