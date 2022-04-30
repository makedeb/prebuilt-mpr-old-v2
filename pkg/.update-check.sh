#!/usr/bin/env bash
set -e
set -o pipefail

get_value() {
	echo "${curl_data}" |
	awk '/Package\: termius-app/' RS='\n\n' |
	grep "^${1}\:" |
	awk -F ': ' '{print $2}'
}

if [[ "$(command -v curl)" == "" ]]; then
    echo "curl doesn't appear to be installed."
    exit 1
fi

source PKGBUILD

curl_data="$(curl -s 'https://deb.termius.com/dists/squeeze/main/binary-amd64/Packages')"

latest_version="$(get_value "Version")"
latest_sha256sum="$(get_value "SHA256")"

if [[ "${pkgver}" == "${latest_version}" ]]; then
    echo "Package is up to date."
    exit 1
fi

echo "Updating PKGBUILD info..."

cat PKGBUILD |
sed "s|pkgver=.*|pkgver='${latest_version}'|" |
sed "s|sha256sums=(.*|sha256sums=('${latest_sha256sum}')|" |
sed "s|pkgrel=.*|pkgrel='1'|" |
tee PKGBUILD

echo "Done."
exit 0
