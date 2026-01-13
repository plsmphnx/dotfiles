# plugin manager
ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
mkdir -p $ZSH_CACHE_DIR
zstyle ':zcomet:*' home-dir $ZSH_CACHE_DIR/zcomet
zstyle ':zcomet:compinit' dump-file $ZSH_CACHE_DIR/compdump
[[ -f $ZSH_CACHE_DIR/zcomet/bin/zcomet.zsh ]] \
||  git clone https://github.com/agkozak/zcomet.git $ZSH_CACHE_DIR/zcomet/bin
source $ZSH_CACHE_DIR/zcomet/bin/zcomet.zsh

# history
HISTFILE=$XDG_STATE_HOME/history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory histignoredups histreduceblanks histverify nosharehistory

# safety aliases
alias rm="rm -i"
alias sudo="sudo "

# convenience aliases
alias del="gio trash"
alias dir="ls -lah"
alias sys="systemctl --system"
alias usr="systemctl --user"

# keybinds
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# right prompt
ZLE_RPROMPT_INDENT=0

# local config
for rc in $XDG_DATA_HOME/zsh/rc/*.zsh(N); source $rc

# local paths
path+=($XDG_BIN_HOME .)

# unique paths
typeset -U path PATH

# core plugins
zcomet load zsh-users/zsh-completions
zcomet compinit
zcomet load zsh-users/zsh-syntax-highlighting
