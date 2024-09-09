if [ $(tty) = /dev/tty1 ]; then
    exec exec-vt 1 systemd-cat -t lockscreen hyprland \
        -c "$XDG_CONFIG_HOME/hypr/hyprland/lock.conf"
fi
