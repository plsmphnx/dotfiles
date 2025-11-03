if [[ -v CARGO_HOME ]]; then
    path+=("$CARGO_HOME/bin")
fi

if [[ -v DOTNET_CLI_HOME ]]; then
    path+=("$DOTNET_CLI_HOME/tools")

    if [[ -n "$commands[dotnet]" ]]; then
        export DOTNET_ROOT=$(dirname $(realpath "$commands[dotnet]"))
        export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    fi
fi

if [[ -v GOPATH ]]; then
    path+=("$GOPATH/bin")
fi

if [[ -v NPM_CONFIG_PREFIX ]]; then
    path+=(./node_modules/.bin "$NPM_CONFIG_PREFIX/bin")
    zcomet load lukechilds/zsh-better-npm-completion
fi
