#!/bin/sh
set -e

GIT_NAME=$(git config --global user.name 2>/dev/null || true)
GIT_EMAIL=$(git config --global user.email 2>/dev/null || true)

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
    echo ""
    echo "ERROR: Git identity is not configured on your host."
    echo "Run the following, then reopen the container:"
    echo ""
    echo '  git config --global user.name  "Your Name"'
    echo '  git config --global user.email "you@example.com"'
    echo ""
    exit 1
fi

printf 'GIT_USER_NAME="%s"\nGIT_USER_EMAIL="%s"\n' "$GIT_NAME" "$GIT_EMAIL" \
    > .devcontainer/.git-env
