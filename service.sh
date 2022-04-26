#!/usr/bin/env bash
#
# This is a file used in the deployed instance. Please ignore it, as it doesn't pertain to the repository itself.
set -e

case "${1}" in
    start)
        docker compose up -d --no-build
        ;;
    stop)
        docker compose down --remove-orphans
        ;;
    update)
        docker compose pull
        ;;
esac

# vim: set sw=4 expandtab:
