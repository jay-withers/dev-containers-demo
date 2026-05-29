#!/bin/sh
set -e

# shellcheck source=/dev/null
. .devcontainer/.git-env
git config --global user.name  "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
# Required when the repo is bind-mounted and owned by a different UID than the container user
git config --global --add safe.directory /workspaces/dev-containers-demo

pre-commit install
