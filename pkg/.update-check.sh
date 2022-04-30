#!/usr/bin/env bash
set -e
set -o pipefail

for i in curl jq; do
    if [[ "$(command -v "${i}")" == "" ]]; then
        echo "${i} doesn't appear to be installed."
        missing_pkg="true"
    fi
done

if [[ "${missing_pkg}" == "true" ]]; then
    exit 1
fi

source PKGBUILD

latest_version="$(curl -s 'https://archlinux.org/packages/search/json/?q=discord' | jq -r '.results[].pkgver')"

if [[ "${pkgver}" == "${latest_version}" ]]; then
    echo "Package is up to date."
    exit 1
fi

echo "Updating PKGBUILD info..."

cat PKGBUILD |
sed "s|pkgver=.*|pkgver='${latest_version}'|" |
sed "s|pkgrel=.*|pkgrel='1'|" |
tee PKGBUILD

echo "Done."
exit 0
