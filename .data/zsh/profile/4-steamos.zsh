if [ "$(tty)" = "/dev/tty4" ]; then
    exec exec-vt 4 systemd-cat -t steamos gamescope-session
fi
