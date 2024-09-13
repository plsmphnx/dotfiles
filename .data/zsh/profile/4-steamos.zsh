[ $(tty) = /dev/tty4 ] && exec exec-vt 4 \
    systemd-cat -t steamos gamescope-session
