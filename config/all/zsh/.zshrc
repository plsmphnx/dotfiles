[[ -s /etc/zinputrc ]] && source /etc/zinputrc
(( $+commands[hostname] )) && export HOST=$(hostname --fqdn)
autoload -Uz add-zsh-hook compinit && compinit

# plugins
: ${ZSH_CACHE_DIR:=$XDG_CACHE_HOME/zsh}
: ${ZSH_PLUGIN_DIR:=/usr/share}

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
source $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
