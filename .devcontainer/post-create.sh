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

# Write Claude Code user settings
mkdir -p "$HOME/.claude"
cat > "$HOME/.claude/settings.json" << 'EOF'
{
    "effortLevel": "high"
}
EOF

# Write MCP server configuration to ~/.claude.json
# Claude Code v2.x reads mcpServers from ~/.claude.json, not settings.json
MCP_SERVERS='{
    "azure": {
        "type": "stdio",
        "command": "npx",
        "args": ["-y", "@azure/mcp@latest", "server", "start"],
        "env": {}
    },
    "microsoft-learn": {
        "type": "http",
        "url": "https://learn.microsoft.com/api/mcp"
    }
}'

if [ -f "$HOME/.claude.json" ]; then
    jq --argjson mcp "$MCP_SERVERS" '.mcpServers = $mcp' "$HOME/.claude.json" > /tmp/claude.json.tmp \
        && mv /tmp/claude.json.tmp "$HOME/.claude.json"
else
    jq -n --argjson mcp "$MCP_SERVERS" '{mcpServers: $mcp}' > "$HOME/.claude.json"
fi
