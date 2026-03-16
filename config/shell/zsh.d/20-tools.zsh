# zsh wrappers for modern tools.

unalias l 2>/dev/null || true
unalias ll 2>/dev/null || true
unalias la 2>/dev/null || true
unalias lt 2>/dev/null || true
unalias tree 2>/dev/null || true
unalias find 2>/dev/null || true
unalias cat 2>/dev/null || true
unalias grep 2>/dev/null || true

if command -v eza >/dev/null 2>&1; then
    l() { eza -l --icons --git -a "$@"; }
    ll() { eza -l --icons --git "$@"; }
    la() { eza -la --icons --git "$@"; }
    lt() { eza --tree --level=2 --long --icons --git "$@"; }
    tree() { eza --tree "$@"; }
elif command -v exa >/dev/null 2>&1; then
    l() { exa -l --icons --git -a "$@"; }
    ll() { exa -l --icons --git "$@"; }
    la() { exa -la --icons --git "$@"; }
    lt() { exa --tree --level=2 --long --icons --git "$@"; }
else
    l() { ls -lah "$@"; }
    ll() { ls -lh "$@"; }
    la() { ls -lAh "$@"; }
fi

if command -v fd >/dev/null 2>&1; then
    fdf() { fd "$@"; }
fi

if command -v bat >/dev/null 2>&1; then
    batcat() { bat --style=auto "$@"; }
fi

if command -v rg >/dev/null 2>&1; then
    rgp() { rg "$@"; }
fi