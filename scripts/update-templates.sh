#!/usr/bin/env bash
#
# This script updates package branches with the template files in templates/.
# Pass in the 'CI_SKIP' environment variable (set to any non-empty value) to append
# '[CI SKIP]' to the generated commit message.
#
# You can also pass in the 'PKGBASE' environment variable to only update
# templates files for a single package.
set -eu

# Get needed information.
git fetch origin
cd "$(git rev-parse --show-toplevel)"
curdir="$(pwd)"
tmpdir="$(mktemp -d)"
mapfile -t packages < <(cat packages.txt)

# If the user passes the 'PKGBASE' env var, only update that package.
if [[ "${PKGBASE:+x}" == "x" ]]; then
    packages=("${PKGBASE}")
fi

cp ./ "${tmpdir}" -R
cd "${tmpdir}"

echo "=== Making sure we're checked out to 'main'..."
git checkout main
echo

# Prune package branches.
echo "=== Pruning package branches..."
mapfile -t pkg_branches < <(git branch --list 'pkg/*' | grep -o 'pkg/.*')

for branch in "${pkg_branches[@]}"; do
    git branch -D "${branch}"
done
echo

for pkg in "${packages[@]}"; do
    echo "=== Updating '${pkg}'... ==="
    cd "${tmpdir}"
    git restore ./

    if ! git rev-parse --verify "origin/pkg/${pkg}" 2> /dev/null; then
        continue
    fi

    git checkout "pkg/${pkg}"
    find ./ -mindepth 1 -maxdepth 1 -not -path './.git' -not -path './pkg' -exec rm -r '{}' +

    cd "${curdir}/templates/packages"
    find ./ -mindepth 1 -maxdepth 1 -exec cp -R '{}' "${tmpdir}/{}" \;
    cd "${tmpdir}"
    git add .

    if [[ "$(git diff --name-only --staged)" != "" ]]; then

        if [[ "${CI_SKIP:+x}" == "x" ]]; then
            commit_msg="Updated template files [CI SKIP]"
        else
            commit_msg="Updated template files"
        fi

        git commit -m "${commit_msg}"
        git push
    fi

    echo
done

echo "${tmpdir}"

# vim: set sw=4 expandtab:
