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
    ln -s "$exe" "$bin"
}

# Add shorthand to mount drives
wslmnt() {
    sudo mkdir /mnt/$1 && sudo mount -t drvfs "${1:u}:\\" /mnt/$1 -o metadata
}
wslumnt() {
    sudo umount /mnt/$1 && sudo rmdir /mnt/$1
}
