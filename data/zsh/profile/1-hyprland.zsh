[ $(tty) = /dev/tty1 ] && exec exec-vt 1 \
    systemctl --user start --wait hyprland
