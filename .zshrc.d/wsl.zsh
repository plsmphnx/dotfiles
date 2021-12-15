# Add Windows user home directory
hash -d _="/mnt/c/Users/$USER"

# Remove Windows paths
path=(${path:#/mnt/*})

# Add utility script
wsl() {
    case $1 in
        path)
            wslpath $2
            ;;

        # Shorthand to build links to Windows programs
        link)
            local exe=$(wslpath $2)
            local bin=~/.bin/${3:-$exe:t:r}
            ln -s "$exe" "$bin"
            ;;

        # Shorthand to (un-)mount drives
        mount)
            sudo mkdir /mnt/$2 && sudo mount -t drvfs "${2:u}:\\" /mnt/$2 -o noatime,uid=1000,gid=1000
            ;;
        unmount)
            sudo umount /mnt/$2 && sudo rmdir /mnt/$2
            ;;
    esac
}
