# bash prompt and directory-jump integrations.

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    parse_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    export PS1="\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[1;33m\]\$(parse_git_branch)\[\033[0m\]\$ "
fi

[ -f "/Users/isaacsunderland/.config/ms-terminal-notif/shell-integration.sh" ] && source "/Users/isaacsunderland/.config/ms-terminal-notif/shell-integration.sh"