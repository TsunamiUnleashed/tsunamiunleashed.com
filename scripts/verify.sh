#!/usr/bin/env bash
set -euo pipefail
PUB=$(cat static/.well-known/minisign.pub)
minisign -Vm public/MANIFEST.json -P "$PUB"
echo "Signature valid."
