if [ "$(tty)" = "/dev/tty3" ]; then
    exec systemd-cat -t hyprland hyprland \
        -c "$XDG_CONFIG_HOME/hypr/desk/land.conf"
fi
