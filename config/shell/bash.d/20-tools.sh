# bash aliases for modern tools.

if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias l="eza -l --icons --git -a"
    alias ll="eza -l --icons --git"
    alias la="eza -la --icons --git"
    alias lt="eza --tree --level=2 --long --icons --git"
    alias tree="eza --tree"
elif command -v exa >/dev/null 2>&1; then
    alias ls="exa"
    alias l="exa -l --icons --git -a"
    alias ll="exa -l --icons --git"
    alias la="exa -la --icons --git"
    alias lt="exa --tree --level=2 --long --icons --git"
else
    alias l="ls -lah"
    alias ll="ls -lh"
    alias la="ls -lAh"
    alias lt="ls -R"
fi

if command -v fd >/dev/null 2>&1; then
    alias find="fd"
fi

if command -v bat >/dev/null 2>&1; then
    alias cat="bat --style=auto"
    alias ccat="/bin/cat"
fi

if command -v rg >/dev/null 2>&1; then
    alias grep="rg"
    alias rgrep="/usr/bin/grep"
else
    alias grep="grep --color=auto"
fi