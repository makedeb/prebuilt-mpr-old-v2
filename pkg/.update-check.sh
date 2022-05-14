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

# If you're running this on your local machine, you'll need to set $github_url
# or manually replace it with GitHub's URL.
api_data="$(curl -sH "Accept: application/vnd.github.v3+json" "https://api.${github_url}/repos/atom/atom/releases/latest")"

latest_version="$(echo "${api_data}" | jq -r .tag_name | rev | head -c -2 | rev)"

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
