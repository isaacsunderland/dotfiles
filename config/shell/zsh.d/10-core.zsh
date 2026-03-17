# Core zsh behavior and keybindings.

# Completion with caching (regenerate daily)
autoload -Uz compinit
_comp_cache="$HOME/.cache/zcompdump"
if [[ -n ${_comp_cache}(#qN.mh+24) ]]; then
    compinit -d "$_comp_cache"
else
    compinit -C -d "$_comp_cache"
fi
unset _comp_cache

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