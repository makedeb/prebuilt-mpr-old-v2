#!/usr/bin/env bash
set -eu

# Install needed packages.
sudo apt install jq -y

# Get needed information.
# We replace ':' with '!' as Git tags in the MPR are stored with the ':' for epochs replaced with '!' due to naming restrictions on Git tags.
pkgname="$(echo "${DRONE_BRANCH}" | sed 's|^pkg/||')"
pkgver="$(git show "${DRONE_BRANCH}:package/${pkgname}" | jq -r '.version' | sed 's|:|!|')"

# Clone the package from the MPR.
git clone "https://mpr.makedeb.org/${pkgname}" -b "${pkgver}"

# Build the package.
cd "${pkgname}/"
makedeb -s --no-confirm
