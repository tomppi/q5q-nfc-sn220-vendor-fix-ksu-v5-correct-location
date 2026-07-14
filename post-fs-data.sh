#!/system/bin/sh
MODDIR=${0%/*}
LOG="$MODDIR/bindmount.log"
SRC="$MODDIR/system/vendor/libnfc-nxp_RF.conf"

{
  echo "=== q5q NFC post-fs-data $(date) ==="
  echo "src=$SRC"
  ls -lZ "$SRC" 2>/dev/null || ls -l "$SRC" 2>/dev/null || echo "missing source RF file"

  # Keep this script conservative: do not remount or modify vendor/system partitions.
  # A bind mount only works when the target placeholder already exists. Most q5q ROMs
  # affected by this bug are missing the target, so a separate overlayfs/Mountify setup
  # that can ADD /system/vendor/libnfc-nxp_RF.conf is normally required.
  for TARGET in /system/vendor/libnfc-nxp_RF.conf /vendor/libnfc-nxp_RF.conf; do
    echo "target=$TARGET"
    if [ -e "$SRC" ] && [ -e "$TARGET" ]; then
      mount -o bind "$SRC" "$TARGET" && echo "bind mounted $SRC -> $TARGET" || echo "bind mount failed for $TARGET"
      ls -lZ "$TARGET" 2>/dev/null || ls -l "$TARGET" 2>/dev/null
    else
      echo "target missing or source missing; use overlayfs/Mountify to add this path"
    fi
  done
} >> "$LOG" 2>&1

exit 0
