#!/bin/sh
# Runs inside the container as postCreateCommand, after the container is created.
set -e

# Apply the git identity captured from the host by init-git-config.sh
# shellcheck source=/dev/null
. .devcontainer/.git-env
git config --global user.name  "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# Required when the repo is bind-mounted and owned by a different UID than the container user
git config --global --add safe.directory /workspaces/dev-containers-demo

# Install the pre-commit hooks defined in .pre-commit-config.yaml
pre-commit install
