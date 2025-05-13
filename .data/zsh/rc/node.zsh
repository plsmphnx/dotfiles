export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/config
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_TMP=$XDG_RUNTIME_DIR/npm

path+=(./node_modules/.bin ~/.node_modules/bin)
zcomet load lukechilds/zsh-better-npm-completion
