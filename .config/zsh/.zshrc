# cache and state
ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
ZSH_STATE_DIR=$XDG_STATE_HOME/zsh

# plugin manager
zstyle ':zcomet:*' home-dir $ZSH_STATE_DIR/zcomet
zstyle ':zcomet:compinit' dump-file $ZSH_STATE_DIR/compdump
[[ -f $ZSH_STATE_DIR/zcomet/bin/zcomet.zsh ]] || \
    git clone https://github.com/agkozak/zcomet.git $ZSH_STATE_DIR/zcomet/bin
source $ZSH_STATE_DIR/zcomet/bin/zcomet.zsh

# history
HISTFILE=$ZSH_STATE_DIR/history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory histignoredups histreduceblanks histverify

# color aliases
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias less="less -R"

# keybinds
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# local paths
path=(. ~/.local/bin $path)

# right prompt
ZLE_RPROMPT_INDENT=0

# local config
for rc in $XDG_DATA_HOME/zsh/*.zsh(N); source $rc

# core plugins
zcomet load zsh-users/zsh-completions
zcomet compinit
zcomet load zsh-users/zsh-syntax-highlighting
