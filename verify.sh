#!/system/bin/sh
su -c '
echo "=== Q5Q NFC SN220 vendor fix v5 verify ==="
echo ""
echo "=== module sepolicy ==="
cat /data/adb/modules/q5q_nfc_sn220_vendor_fix/sepolicy.rule 2>/dev/null || echo "missing sepolicy.rule"

echo ""
echo "=== visible files ==="
for p in \
  /vendor/etc/libnfc-nxp.conf \
  /vendor/libnfc-nxp_RF.conf \
  /system/vendor/libnfc-nxp_RF.conf \
  /vendor/etc/nfc/libnfc-nxp_RF.conf \
  /vendor/etc/libnfc-nxp_RF.conf \
  /vendor/lib64/libsn220u_fw.so \
  /vendor/firmware/nfc/libsn220u_fw.so \
  /data/vendor/nfc/libnfc-nxpTransit.conf; do
  if [ -e "$p" ]; then
    ls -lZ "$p" 2>/dev/null || ls -l "$p" 2>/dev/null
  else
    echo "missing: $p"
  fi
done

echo ""
echo "=== ROM config values currently used ==="
grep -nE "NXP_NFC_DEV_NODE|NXP_FW_NAME|FW_STORAGE|RF_STORAGE|NXP_FLASH_CONFIG|NXP_FW_TYPE|NXP_RDR_DISABLE_ENABLE_LPCD|NFA_CONFIG_FORMAT|DEFAULT_(AID|OFFHOST|ISODEP|SYS_CODE|MIFARE|FELICA)" /vendor/etc/libnfc-nxp.conf 2>/dev/null || true

echo ""
echo "=== NFC clean restart ==="
logcat -c
svc nfc disable
sleep 3
svc nfc enable
sleep 12

echo ""
echo "=== dumpsys nfc state ==="
dumpsys nfc | sed -n "1,22p"

echo ""
echo "=== NFC errors / denials ==="
logcat -d -b all | grep -iE "avc:.*nfc|hal_nfc|nfc|nxp|pn547|sn220|RF.conf|Transit|Error loading FW|Cannot open config|_i2c_open|phTmlNfc_Init|Open Error|NFA_DM_ENABLE_EVT|unknown opcode|Polling Loop Started|RF_DISCOVERY_STARTED" | tail -260
'
