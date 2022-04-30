#!/usr/bin/env bash
set -eu

# Env vars.
proget_url='proget.hunterwittenborn.com'
pkgname="$(echo "${DRONE_BRANCH}" | sed 's|pkg/||')"

# Install needed packages.
sudo apt update
sudo apt install jq git gpg curl lsb-release -y

# Add Prebuilt-MPR repository to system so we can access packages from there during builds.
curl -q "https://${proget_url}/debian-feeds/prebuilt-mpr.pub" | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://${proget_url} prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
sudo apt update

# Set perms on current directory and pkgdir, since Drone CI clones under 'root' by default.
sudo chown 'makedeb:makedeb' ./ /var/tmp/prebuilt-mpr/ -R

# Build the package.
cp ./pkg "/var/tmp/prebuilt-mpr/${pkgname}" -R
cd "/var/tmp/prebuilt-mpr/${pkgname}"
makedeb -s --no-confirm --skip-pgp-check
