# bash-specific shell configuration loader.

if [ -d "$HOME/.config/shell/bash.d" ]; then
    for bash_conf in "$HOME/.config/shell/bash.d"/*.sh; do
        [ -e "$bash_conf" ] || continue
        source "$bash_conf"
    done
fi