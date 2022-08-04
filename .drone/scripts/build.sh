#!/usr/bin/env bash
set -eu

# If we specified a list of distros to build on and the current distro isn't in that, skip the build.
if [[ "${distros:+x}" == 'x' ]]; then
    if ! echo "${distros}" | sed 's|,|\n|g' | grep -q "${distro_codename}"; then
        echo "Skipping build for '${distro_codename}'..."
        exit 0
    fi
fi

# Env vars.
proget_url='proget.hunterwittenborn.com'
pkgname="$(echo "${DRONE_BRANCH}" | sed 's|pkg/||')"
pkgdir="/mnt/prebuilt-mpr/${pkgname}/${distro_codename}"

# Install needed packages.
sudo apt update
sudo apt install jq git gpg curl lsb-release locales-all -y
sudo apt-get install wget sudo apt-utils ca-certificates apt-transport-https -y
sudo apt-get install lsb-release gettext wget curl build-essential cmake g++ sudo gpg git autoconf automake libtool pkg-config libpthread-stubs0-dev libssl-dev libevent-pthreads-2.1-7 zstd -y

# Add Prebuilt-MPR repository to system so we can access packages from there during builds.
if [[ "${exclude_pbmpr:-x}" == 'x' ]]; then
    curl -q "https://${proget_url}/debian-feeds/prebuilt-mpr.pub" | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://${proget_url} prebuilt-mpr ${distro_codename}" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
    sudo apt update
fi

# Set perms on current directory and pkgdir, since Drone CI clones under 'root' by default.
sudo chown 'makedeb:makedeb' ./ /mnt/prebuilt-mpr/ -R

# Destroy all files in pkgdir.
find "${pkgdir}" -mindepth 1 -maxdepth 1 -exec rm -rf '{}' +

# Copy files to the packaging directory and build the package.
# We pass '--pass-env' so that the DEBIAN_FRONTEND variable (which is set in
# the Drone CI environment automatically in our instance) is exposed to
# 'sudo apt-get' calls.
cd pkg/
find ./ -mindepth 1 -maxdepth 1 -exec cp '{}' "${pkgdir}/{}" -R \;
cd "${pkgdir}"
makedeb -s --no-confirm --skip-pgp-check --pass-env

# vim: set sw=4 expandtab:
