#!/system/bin/sh
# No persistent vendor/system files are written by this module.
# Remove any external Mountify/overlayfs rule separately if you created one.
rm -f /data/adb/modules/q5q_nfc_sn220_vendor_fix/bindmount.log 2>/dev/null
exit 0
