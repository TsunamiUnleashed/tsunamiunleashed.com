#!/usr/bin/env bash
set -euo pipefail
DATE=$(date -u +%Y-%m)
mkdir -p public/bundles
pagedjs-cli http://localhost:8080/print/field-guide/ \
  --output "public/bundles/LifeWithGod_FieldGuide_EN_v${DATE}_A5.pdf"
pagedjs-cli http://localhost:8080/print/cards/ \
  --output "public/bundles/BookmarkCards_EN_v${DATE}_A4.pdf"
pagedjs-cli http://localhost:8080/print/commands/ \
  --output "public/bundles/8GC_EN_v${DATE}_A4.pdf"
