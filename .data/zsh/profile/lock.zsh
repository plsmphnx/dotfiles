if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 2 ]; then
  exec cage -ds -- quickshell -c lock
fi
