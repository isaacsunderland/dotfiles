# zsh prompt and directory-jump integrations (cached for performance).

# Cache zoxide init (regenerate with: zoxide init zsh > ~/.cache/zoxide-init.zsh)
if [ -f "$HOME/.cache/zoxide-init.zsh" ]; then
    source "$HOME/.cache/zoxide-init.zsh"
elif command -v zoxide >/dev/null 2>&1; then
    mkdir -p "$HOME/.cache"
    zoxide init zsh > "$HOME/.cache/zoxide-init.zsh"
    source "$HOME/.cache/zoxide-init.zsh"
fi

# Cache starship init (regenerate with: starship init zsh > ~/.cache/starship-init.zsh)
if [ -f "$HOME/.cache/starship-init.zsh" ]; then
    source "$HOME/.cache/starship-init.zsh"
elif command -v starship >/dev/null 2>&1; then
    mkdir -p "$HOME/.cache"
    starship init zsh > "$HOME/.cache/starship-init.zsh"
    source "$HOME/.cache/starship-init.zsh"
fi

export PATH="/Library/Application Support/com.canonical.multipass/bin:$PATH"