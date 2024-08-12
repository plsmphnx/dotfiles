if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 3 ]; then
  exec systemd-cat -t hyprland hyprland
fi
