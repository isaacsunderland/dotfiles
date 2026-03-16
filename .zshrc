# Zsh configuration file
# No Nix required - pure shell

if [ -f "$HOME/.config/shell/common.sh" ]; then
    source "$HOME/.config/shell/common.sh"
fi

if [ -f "$HOME/.config/shell/zsh.sh" ]; then
    source "$HOME/.config/shell/zsh.sh"
fi
