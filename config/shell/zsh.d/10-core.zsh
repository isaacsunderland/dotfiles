# Core zsh behavior and keybindings.

autoload -U compinit && compinit
autoload bashcompinit && bashcompinit

setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

bindkey -M vicmd 'j' beginning-of-line
bindkey -M vicmd 'k' end-of-line

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey -M vicmd '^R' history-incremental-search-backward
bindkey -M vicmd '^S' history-incremental-search-forward

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh