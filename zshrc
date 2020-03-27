# ZSH BUNDLES
source $HOME/.shell/zsh_plugins.sh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=1'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#fffefe"

# SHELL CONFIG
source $HOME/.sensitive
source $HOME/.shell/aliases
source $HOME/.shell/completion
source $HOME/.shell/functions
source $HOME/.shell/managers
source $HOME/.shell/options
source $HOME/.shell/path

export TERM=xterm-256color

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
