#!/usr/bin/env bash
#
# This script deletes all package branches not defined in 'packages.txt'.
# Note that this script also deletes local copies of said branches.
set -eu

# Get needed information.
git fetch origin
cd "$(git rev-parse --show-toplevel)"
mapfile -t packages < <(cat packages.txt)

echo "=== Making sure we're checked out to 'main'..."
git checkout main
echo

echo "=== Deleting all unused local package branches..."
mapfile -t local_pkg_branches < <(git branch --list 'pkg/*' | grep -o 'pkg/.*')

for branch in "${local_pkg_branches[@]}"; do
    git branch -D "${branch}"
done
echo

echo "=== Deleting all unused remote package branches..."
used_remote_pkg_branches=()
unused_remote_pkg_branches=()
mapfile -t remote_pkg_branches < <(git branch --remotes --list 'origin/pkg*' | grep -o 'origin/pkg.*' | sed 's|^origin/||')

for branch in "${remote_pkg_branches[@]}"; do
    if printf 'pkg/%s\n' "${packages[@]}" | grep -qF "${branch}"; then
        used_remote_package_branches+=("${branch}")
    fi

    if printf 'pkg-update/%s\n' "${packages[@]}" | grep -qF "${branch}"; then
        used_remote_package_branches+=("${branch}")
    fi
done

for branch in "${remote_pkg_branches[@]}"; do
    if ! printf '%s\n' "${used_remote_package_branches[@]}" | grep -qF "${branch}"; then
        unused_remote_pkg_branches+=("${branch}")
    fi
done

for branch in "${unused_remote_pkg_branches[@]}"; do
    git push -d origin "${branch}"
done

# vim: set sw=4 expandtab:
