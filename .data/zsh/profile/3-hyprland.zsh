if [ "$(tty)" = "/dev/tty3" ]; then
    exec exec-vt 3 systemd-cat -t desktop hyprland \
        -c "$XDG_CONFIG_HOME/hypr/hyprland/desk.conf"
fi
