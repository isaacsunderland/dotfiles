# Bash configuration file
# Fallback when zsh is not available

if [ -f "$HOME/.config/shell/common.sh" ]; then
    source "$HOME/.config/shell/common.sh"
fi

if [ -f "$HOME/.config/shell/bash.sh" ]; then
    source "$HOME/.config/shell/bash.sh"
fi
