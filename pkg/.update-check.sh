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

api_data="$(curl -sH "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/drone/drone-cli/releases/latest")"

latest_version="$( echo "${api_data}" | jq -r '.tag_name' | rev | head -c -2 | rev)"

if [[ "${pkgver}" == "${latest_version}" ]]; then
    echo "Package is up to date."
    exit 1
fi

echo "Updating PKGBUILD info..."

number=1
for i in $(echo "${api_data}" | jq -r .assets[].name); do
    if [[ "${i}" == "drone_checksums.txt" ]]; then
        break
    elif [[ "${i}" == "" ]]; then
        echo "Couldn't find the checksum file. Aborting..."
        exit 1
    fi

    number="$(( "${number}" + 1 ))"
done

checksum_url="$(echo "${api_data}" | jq -r '.assets[].browser_download_url' | xargs | awk "{print \$$number}")"
checksum_value="$(curl -Ls "${checksum_url}" | grep 'drone_linux_amd64.tar.gz' | awk '{print $1}')"

sed -i "s|pkgver=.*|pkgver='${latest_version}'|" PKGBUILD
sed -i "s|sha256sums_x86_64=.*|sha256sums_x86_64=('${checksum_value}')|" PKGBUILD

echo "Done."
exit 0
