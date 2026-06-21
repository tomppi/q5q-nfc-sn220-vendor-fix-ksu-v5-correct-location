#!/system/bin/sh
MODDIR=${0%/*}
# Nothing to bind-mount here. The important test is the normal module overlay:
#   system/vendor/libnfc-nxp_RF.conf -> /vendor/libnfc-nxp_RF.conf
# Do not override /vendor/etc/libnfc-nxp.conf in v5.
exit 0
