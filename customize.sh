#!/system/bin/sh
ui_print "Installing Q5Q NFC SN220 vendor RF config fix v7.1"
ui_print "Keeps the ROM /vendor/etc/libnfc-nxp.conf unchanged."
ui_print "Provides the q5q SN220 RF file for the HAL path:"
ui_print "  /system/vendor/libnfc-nxp_RF.conf"
ui_print "If KernelSU cannot create that vendor-root file, use Mountify/overlayfs with:"
ui_print "  source: /data/adb/modules/q5q_nfc_sn220_vendor_fix/system"
ui_print "  target: /system"
ui_print "Do not install GitHub source zips directly; use the workflow-built module zip."
