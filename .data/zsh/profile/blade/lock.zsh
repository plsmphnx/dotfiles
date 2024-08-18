if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  NVIDIA=$(basename $(readlink -f "/dev/dri/by-path/pci-0000:01:00.0-card"))
  exec systemd-cat -t weston weston --drm-device $NVIDIA
fi
