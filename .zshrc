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

# Aliases - Modern tools with POSIX fallbacks
# ls replacement (eza/exa with fallback to ls)
if command -v eza &> /dev/null; then
    alias ls="eza"
    alias l="eza -l --icons --git -a"
    alias ll="eza -l --icons --git"
    alias la="eza -la --icons --git"
    alias lt="eza --tree --level=2 --long --icons --git"
    alias tree="eza --tree"
elif command -v exa &> /dev/null; then
    alias ls="exa"
    alias l="exa -l --icons --git -a"
    alias ll="exa -l --icons --git"
    alias la="exa -la --icons --git"
    alias lt="exa --tree --level=2 --long --icons --git"
else
    # POSIX fallback
    alias l="ls -lah"
    alias ll="ls -lh"
    alias la="ls -lAh"
fi

# find replacement (fd with fallback to find)
if command -v fd &> /dev/null; then
    alias find="fd"
fi

# cat replacement (bat with fallback to cat)
if command -v bat &> /dev/null; then
    alias cat="bat --style=auto"
    alias ccat="/bin/cat"  # original cat
fi

# grep replacement (ripgrep with fallback to grep)
if command -v rg &> /dev/null; then
    alias grep="rg"
    alias rgrep="/usr/bin/grep"  # original grep
fi

# Standard aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Editor fallback chain: neovim -> vim -> vi
if command -v nvim &> /dev/null; then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR="nvim"
    export VISUAL="nvim"
elif command -v vim &> /dev/null; then
    alias vi="vim"
    export EDITOR="vim"
    export VISUAL="vim"
else
    export EDITOR="vi"
    export VISUAL="vi"
fi

# Ensure homebrew nano takes precedence (if installed)
if [ -x /opt/homebrew/bin/nano ]; then
    alias nano="/opt/homebrew/bin/nano"
fi

# Navigation functions
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { 
    local file="$(find . -type f -not -path '*/.*' | fzf)"
    if [ -n "$file" ]; then
        $EDITOR "$file"
    fi
}

# Zoxide integration (modern cd replacement)
eval "$(zoxide init zsh)"

# Initialize starship prompt
eval "$(starship init zsh)"
