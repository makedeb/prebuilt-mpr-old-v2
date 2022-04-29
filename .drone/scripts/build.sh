#!/usr/bin/env bash
set -eu

# Install needed packages.
sudo apt update
sudo apt install jq git -y

# Get needed information.
# We replace ':' with '!' as Git tags in the MPR are stored with the ':' for epochs replaced with '!' due to naming restrictions on Git tags.
pkgname="$(echo "${DRONE_BRANCH}" | sed 's|^pkg/||')"
pkgver="$(echo "${version}" | sed 's|:|!|')"

# Set perms on and chdir into build directory.
chown 'makedeb:makedeb' '/tmp/prebuilt-mpr' -R
cd '/tmp/prebuilt-mpr'

# Clone the package from the MPR.
git clone "https://mpr.makedeb.org/${pkgname}" -b "ver/${pkgver}"

# Build the package.
cd "${pkgname}/"
makedeb -s --no-confirm --skip-pgp-check
