#!/usr/bin/env bash
set -euo pipefail
printf '%s' "$MINISIGN_SECRET_KEY" > /tmp/tsunami-sign.key
chmod 600 /tmp/tsunami-sign.key
minisign -Sm public/MANIFEST.json -s /tmp/tsunami-sign.key
shred -u /tmp/tsunami-sign.key
