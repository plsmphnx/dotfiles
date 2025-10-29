# cache and state
ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
mkdir -p $ZSH_CACHE_DIR
ZSH_STATE_DIR=$XDG_STATE_HOME/zsh
mkdir -p $ZSH_STATE_DIR

# plugin manager
zstyle ':zcomet:*' home-dir $ZSH_CACHE_DIR/zcomet
zstyle ':zcomet:compinit' dump-file $ZSH_CACHE_DIR/compdump
[[ -f $ZSH_CACHE_DIR/zcomet/bin/zcomet.zsh ]] || \
    git clone https://github.com/agkozak/zcomet.git $ZSH_CACHE_DIR/zcomet/bin
source $ZSH_CACHE_DIR/zcomet/bin/zcomet.zsh

# history
HISTFILE=$XDG_STATE_HOME/history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory histignoredups histreduceblanks histverify nosharehistory

# color aliases
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias less="less -R"
alias ls="ls --color=auto"

# safety aliases
alias rm="rm -i"
alias sudo="sudo "

# convenience aliases
alias del="gio trash"
alias dev="nix develop --no-write-lock-file --inputs-from /etc/nixos --command zsh"
alias dir="ls -lah"
alias sys="systemctl --system"
alias usr="systemctl --user"

# keybinds
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# right prompt
ZLE_RPROMPT_INDENT=0

# unique paths
typeset -U path PATH

# local config
for rc in $XDG_DATA_HOME/zsh/rc/*.zsh(N); source $rc

# local paths
path+=($XDG_BIN_HOME .)

# core plugins
zcomet load zsh-users/zsh-completions
zcomet compinit
zcomet load zsh-users/zsh-syntax-highlighting
