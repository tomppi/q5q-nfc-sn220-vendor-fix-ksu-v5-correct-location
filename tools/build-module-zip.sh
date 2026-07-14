#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT/out"
ZIP_NAME="q5q-nfc-sn220-vendor-fix-ksu-v7.1.zip"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

cd "$ROOT"

# Build an installable module zip with module files at archive root.
# Do not use GitHub's automatic source zip for installation.
zip -r9 "$OUT_DIR/$ZIP_NAME" \
  module.prop \
  customize.sh \
  post-fs-data.sh \
  service.sh \
  sepolicy.rule \
  uninstall.sh \
  verify.sh \
  system \
  README.md \
  -x '*.git*' 'out/*' 'tools/*'

sha256sum "$OUT_DIR/$ZIP_NAME" > "$OUT_DIR/$ZIP_NAME.sha256"
echo "Built: $OUT_DIR/$ZIP_NAME"
cat "$OUT_DIR/$ZIP_NAME.sha256"
