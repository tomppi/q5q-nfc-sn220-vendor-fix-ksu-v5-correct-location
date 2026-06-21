Q5Q NFC SN220 vendor fix v5 - correct RF conf location

This version follows the Exynoobs q5q device tree commit shown by the user:
  vendor/etc/nfc/libnfc-nxp_RF.conf:vendor/libnfc-nxp_RF.conf

Meaning: extract the RF config blob from stock vendor/etc/nfc but install it into the ROM at vendor/libnfc-nxp_RF.conf.

This module intentionally does NOT overlay /vendor/etc/libnfc-nxp.conf, so the ROM's own NXP config remains in control. That should make the HAL look for the same path it logged earlier: /system/vendor/libnfc-nxp_RF.conf, which corresponds to /vendor/libnfc-nxp_RF.conf.
