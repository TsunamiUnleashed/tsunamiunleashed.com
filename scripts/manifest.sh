#!/usr/bin/env bash
set -euo pipefail
cd public
VERSION=$(git -C .. describe --tags --always 2>/dev/null || echo "untagged")
COMMIT=$(git -C .. rev-parse HEAD 2>/dev/null || echo "unknown")
BUILT_AT=$(date -u +%Y-%m-%dT%H:%M:%SZ)
{
  echo "{"
  echo "  \"version\": \"$VERSION\","
  echo "  \"commit\": \"$COMMIT\","
  echo "  \"built_at\": \"$BUILT_AT\","
  echo "  \"files\": ["
  find . -type f \
    ! -name 'MANIFEST.json' \
    ! -name 'MANIFEST.json.minisig' \
    -print0 \
    | sort -z \
    | xargs -0 -I{} sh -c \
      'printf "    {\"path\": \"%s\", \"sha256\": \"%s\"}\n" \
       "${1#./}" "$(sha256sum "$1" | cut -d" " -f1)"' _ {} \
    | paste -sd ',\n' -
  echo "  ]"
  echo "}"
} > MANIFEST.json
