if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 4 ]; then
    exec systemd-cat -t steamos gamescope-session
fi
