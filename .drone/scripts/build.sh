#!/usr/bin/env bash
set -eu

# Env vars.
proget_url='proget.hunterwittenborn.com'
pkgname="$(echo "${DRONE_BRANCH}" | sed 's|pkg/||')"
pkgdir="/var/tmp/prebuilt-mpr/${pkgname}/${distro_codename}"

# Install needed packages.
sudo apt update
sudo apt install jq git gpg curl lsb-release -y

# Add Prebuilt-MPR repository to system so we can access packages from there during builds.
if [[ "${exclude_pbmpr:-x}" == 'x' ]]; then
    curl -q "https://${proget_url}/debian-feeds/prebuilt-mpr.pub" | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://${proget_url} prebuilt-mpr ${distro_codename}" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
    sudo apt update
fi

# Set perms on current directory and pkgdir, since Drone CI clones under 'root' by default.
sudo chown 'makedeb:makedeb' ./ /var/tmp/prebuilt-mpr/ -R

# Destroy all files in pkgdir.
find "${pkgdir}" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' +

# Build the package.
cd pkg/
find ./ -mindepth 1 -maxdepth 1 -exec cp '{}' "${pkgdir}/{}" -R \;
cd "${pkgdir}"
makedeb -s --no-confirm --skip-pgp-check

# vim: set sw=4 expandtab:
