INTEL=$(readlink -f /dev/dri/by-path/pci-0000:00:02.0-card)
NVIDIA=$(readlink -f /dev/dri/by-path/pci-0000:01:00.0-card)
systemctl --user set-environment    \
    AQ_DRM_DEVICES=$NVIDIA:$INTEL   \
    MESA_VK_DEVICE_SELECT=10de:249c \
