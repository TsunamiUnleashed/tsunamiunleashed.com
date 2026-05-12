#!/usr/bin/env bash
set -euo pipefail
DATE=$(date -u +%Y-%m)
mkdir -p public/bundles
monolith http://localhost:8080/pack/ \
  --no-audio --no-video \
  --output "public/bundles/TsunamiUnleashed_Complete_EN_v${DATE}.html"
SIZE=$(stat -c%s "public/bundles/TsunamiUnleashed_Complete_EN_v${DATE}.html")
if [ "$SIZE" -gt 50000000 ]; then
  echo "ERROR: bundle exceeds 50MB ($SIZE bytes). Investigate." >&2; exit 1
fi
echo "Bundle size: $((SIZE / 1024))KB"
