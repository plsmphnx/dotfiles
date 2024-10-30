[ $(tty) = /dev/tty1 ] && exec exec-vt 1 \
    systemd-cat -t desktop Hyprland
