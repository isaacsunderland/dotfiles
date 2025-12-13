# Zsh configuration file
# No Nix required - pure shell

# Enable command completion
autoload -U compinit && compinit

# Set up shell options
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enable bash completion compatibility
autoload bashcompinit && bashcompinit

# Set PATH
export PATH="/opt/homebrew/bin:$PATH"

# Vim mode
bindkey -M vicmd 'j' beginning-of-line
bindkey -M vicmd 'k' end-of-line

# FZF integration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Z.sh for navigation (directory jumping)
. /opt/homebrew/etc/profile.d/z.sh

# Aliases
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias vim="nvim"

# Navigation functions
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

# Zoxide integration (modern cd replacement)
eval "$(zoxide init zsh)"

# Initialize starship prompt
eval "$(starship init zsh)"
