#!/usr/bin/env bash
set -eu

# Install needed packages.
sudo apt update
sudo apt install jq git -y

# Set perms on current directory, since Drone CI clones under 'root' by default.
sudo chown 'makedeb:makedeb' ./ -R

# Build the package.
cd pkg/
makedeb -s --no-confirm --skip-pgp-check
