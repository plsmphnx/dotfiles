# Add X output
export DISPLAY=127.0.0.1:0.0
export LIBGL_ALWAYS_INDIRECT=1

# Add Windows user home directory
hash -d _="/mnt/c/Users/$USER"

# Remove Windows paths
path=(${path:#/mnt/*})
