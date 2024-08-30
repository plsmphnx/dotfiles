if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 3 ]; then
    exec systemd-cat -t hyprland hyprland \
        -c "$XDG_CONFIG_HOME/hypr/desk/land.conf"
fi
