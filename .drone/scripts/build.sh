#!/usr/bin/env bash
set -eu

# Drone exec runner doesn't support env extensions right now, which this variable is sources from.
hw_url='hunterwittenborn.com'

docker login -u api -p "${proget_api_key}" "proget.${hw_url}"
docker compose build --no-cache
docker compose push
