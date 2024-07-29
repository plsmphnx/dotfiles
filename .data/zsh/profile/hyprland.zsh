if [ "$DISPLAY" != "wayland" ] && [ "$XDG_VTNR" = 3 ]; then
  exec Hyprland
fi
