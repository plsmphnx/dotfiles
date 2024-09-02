if [ "$(tty)" = "/dev/tty4" ]; then
    exec systemd-cat -t steamos gamescope-session
fi
