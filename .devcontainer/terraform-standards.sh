#!/bin/sh
# Enforces that Terraform data source blocks are only defined in files named data.tf.

VIOLATIONS=$(grep -rl '^data "' . --include="*.tf" \
    | grep -v '/data\.tf$' \
    | grep -v '/\.terraform/')

if [ -n "$VIOLATIONS" ]; then
    echo "Terraform data sources must be defined in data.tf. Found in:"
    printf '%s\n' "$VIOLATIONS" | sed 's|^\./||' | sed 's/^/  /'
    exit 1
fi
