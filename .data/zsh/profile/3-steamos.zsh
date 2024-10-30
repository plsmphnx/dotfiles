[ $(tty) = /dev/tty3 ] && exec exec-vt 3 \
    systemd-cat -t steamos gamescope-session
