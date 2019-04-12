# environment
[[ -d ~/.zsh ]] || mkdir ~/.zsh
path+=(.)

# plugin manager
declare -A ZPLGM
ZPLGM[HOME_DIR]=~/.zsh/plugin
export ZPLG_HOME=~/.zsh/plugin
[[ -d $ZPLG_HOME ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
source "$ZPLG_HOME/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# history
HISTFILE=~/.zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory histignoredups histreduceblanks histverify incappendhistory sharehistory

# color aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# local config
for rc in ~/.zshrc.d/*.zsh(N); source $rc

# core plugins
zplugin light zsh-users/zsh-completions
autoload -Uz compinit; compinit -i
zplugin cdreplay -q
zplugin light zsh-users/zsh-syntax-highlighting
zplugin light zsh-users/zsh-history-substring-search
