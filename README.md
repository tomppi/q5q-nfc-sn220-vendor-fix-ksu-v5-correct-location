# Q5Q NFC SN220 vendor RF config fix

KernelSU/ReSukiSU module for Samsung Galaxy Z Fold5 `q5q` LineageOS NFC testing.

## What this fixes

On the affected q5q build, the NXP NFC HAL reads the ROM config from:

```txt
/vendor/etc/libnfc-nxp.conf
```

but then tries to load the RF tuning file from:

```txt
/system/vendor/libnfc-nxp_RF.conf
```

The working fix is to make the q5q SN220 RF file visible at one of these vendor-root paths:

```txt
/system/vendor/libnfc-nxp_RF.conf
/vendor/libnfc-nxp_RF.conf
```

The ROM-source fix is equivalent to the Exynoobs q5q proprietary-files mapping:

```txt
vendor/etc/nfc/libnfc-nxp_RF.conf:vendor/libnfc-nxp_RF.conf
```

## Which ZIP to flash

Use the direct flashable ZIP from **GitHub Releases**:

```txt
q5q-nfc-sn220-vendor-fix-ksu-v7.1.zip
```

Do **not** flash GitHub's automatic source-code ZIP.

Do **not** flash the GitHub Actions artifact wrapper ZIP directly. Actions artifact downloads are wrapper ZIPs; if you use one, extract it first and then flash the inner `q5q-nfc-sn220-vendor-fix-ksu-v7.1.zip`.

Flashing the wrong wrapper/source zip can make KernelSU/ReSukiSU identify the module as `unknown` or fail with:

```txt
Error: specified file not found in archive
```

The installable module zip must have `module.prop`, `customize.sh`, `post-fs-data.sh`, and `sepolicy.rule` at the archive root.

## Overlayfs / Mountify note

A simple bind mount only works if the target file already exists. On the broken ROM, `/system/vendor/libnfc-nxp_RF.conf` is missing, so you need an overlayfs/Mountify method that can **add** a new file into `/vendor`/`/system/vendor`.

The working external overlay should expose:

```txt
source: /data/adb/modules/q5q_nfc_sn220_vendor_fix/system
 target: /system
```

or single-file equivalent:

```txt
source: /data/adb/modules/q5q_nfc_sn220_vendor_fix/system/vendor/libnfc-nxp_RF.conf
 target: /system/vendor/libnfc-nxp_RF.conf
```

If your kernel lacks `CONFIG_TMPFS_XATTR=y`, tmpfs-backed overlay helpers may not preserve SELinux labels correctly. Prefer an overlayfs method with upper/work directories on `/data`.

## Build locally

```sh
chmod +x tools/build-module-zip.sh
./tools/build-module-zip.sh
```

Then flash:

```txt
out/q5q-nfc-sn220-vendor-fix-ksu-v7.1.zip
```

## Verify

After install/reboot and after enabling your working overlayfs rule:

```sh
su
sh /data/adb/modules/q5q_nfc_sn220_vendor_fix/verify.sh
```

The important failure line must be gone:

```txt
readConfig Cannot open config file /system/vendor/libnfc-nxp_RF.conf
```

NFC tag detection should then produce events such as:

```txt
NFA_ACTIVATED
NfcTag
NfcDispatcher
```
