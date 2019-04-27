# Add X output
export DISPLAY=127.0.0.1:0.0
export LIBGL_ALWAYS_INDIRECT=1

# Add Windows user home directory
hash -d _="/mnt/c/Users/$USER"

# Remove Windows paths
path=(${path:#/mnt/*})

# Add shorthand to build links to Windows programs
wslbin() {
    local exe=$(wslpath $1)
    local bin=~/.bin/${2:-$exe:t:r}
    echo "${(q)exe} \"\$@\"" > $bin
    chmod +x $bin
}
