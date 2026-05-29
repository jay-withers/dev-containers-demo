#!/bin/sh
# Enforces Terraform file naming standards for data, outputs, locals, and variables.

FAILED=0

check() {
    LABEL="$1"
    PATTERN="$2"
    VALID_GREP="$3"

    VIOLATIONS=$(grep -rl "$PATTERN" . --include="*.tf" \
        | grep -v "$VALID_GREP" \
        | grep -v '/\.terraform/')

    if [ -n "$VIOLATIONS" ]; then
        echo "$LABEL must be defined in $LABEL files. Found in:"
        printf '%s\n' "$VIOLATIONS" | sed 's|^\./||' | sed 's/^/  /'
        FAILED=1
    fi
}

check "data sources"  '^data "'      '/data\.tf$'
check "outputs"       '^output "'    '/outputs-[^/]*\.tf$'
check "locals"        '^locals {'    '/locals-[^/]*\.tf$'
check "variables"     '^variable "'  '/variables-[^/]*\.tf$'

exit $FAILED
