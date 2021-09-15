#!/bin/bash
set -e

# This script is executed inside the Docker container each time it is started

# exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"