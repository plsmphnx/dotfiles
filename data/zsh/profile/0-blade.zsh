INTEL=$(readlink -f /dev/dri/by-path/pci-0000:00:02.0-card)
NVIDIA=$(readlink -f /dev/dri/by-path/pci-0000:01:00.0-card)
export AQ_DRM_DEVICES="$NVIDIA:$INTEL"
systemctl --user import-environment AQ_DRM_DEVICES
