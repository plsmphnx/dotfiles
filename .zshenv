for conf in $HOME/.config/environment.d/*.conf; do
    while read -r env; do export ${(e)env}; done < $conf
done
