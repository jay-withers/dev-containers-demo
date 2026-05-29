#!/bin/sh
set -e

# shellcheck source=/dev/null
. .devcontainer/.git-env
git config --global user.name  "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

pre-commit install
