# zsh kubectl completion.

if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)

    if command -v kubectl-cnpg >/dev/null 2>&1; then
        _ensure_kubectl_cnpg_completion_helper
    fi
fi