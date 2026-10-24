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
compinit
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
