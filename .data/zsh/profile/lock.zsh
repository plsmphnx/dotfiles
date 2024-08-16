if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 2 ]; then
  exec systemd-cat -t weston weston
fi
