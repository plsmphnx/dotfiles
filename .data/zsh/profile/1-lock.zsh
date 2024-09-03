if [ "$(tty)" = "/dev/tty1" ]; then
    exec systemd-cat -t hyprland hyprland \
        -c "$XDG_CONFIG_HOME/hypr/land/lock.conf"
fi
