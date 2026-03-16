# zsh-specific shell configuration loader.

for zsh_conf in "$HOME/.config/shell/zsh.d"/*.zsh(N); do
    source "$zsh_conf"
done