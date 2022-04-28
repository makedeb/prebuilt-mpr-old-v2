#!/usr/bin/env bash
set -eu

sudo apt install curl jq -y
curl -Ls 'https://shlink.hunterwittenborn.com/ci-utils' | bash -

# Set up SSH.
mkdir -p "${HOME}/.ssh/"
echo "${ssh_key}" | tee "/${HOME}/.ssh/ssh_key"

github_ssh_fingerprint="$(curl "https://api.${github_url}/meta" | jq -r '.ssh_key_fingerprints.SHA256_ECDSA')"

SSH_HOST="${github_url}" \
SSH_EXPECTED_FINGERPRINT="${github_ssh_fingerprint}" \
SET_PERMS='true' \
get-ssh-key

# vim: set sw=4 expandtab:
