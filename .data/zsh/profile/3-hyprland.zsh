[ $(tty) = /dev/tty3 ] && exec exec-vt 3 \
    systemd-cat -t desktop Hyprland \
        -c "$XDG_CONFIG_HOME/hypr/hyprland/desk.conf"
