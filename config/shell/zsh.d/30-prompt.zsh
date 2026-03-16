# zsh prompt and directory-jump integrations.

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

export PATH="/Library/Application Support/com.canonical.multipass/bin:$PATH"