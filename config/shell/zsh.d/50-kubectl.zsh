# zsh kubectl completion (lazy loaded for performance).

# Lazy load kubectl completion on first use
kubectl() {
    unfunction kubectl 2>/dev/null
    if command -v kubectl >/dev/null 2>&1; then
        # Load completion
        source <(command kubectl completion zsh)
        # Set up cnpg completion helper if needed
        if command -v kubectl-cnpg >/dev/null 2>&1; then
            _ensure_kubectl_cnpg_completion_helper
        fi
    fi
    command kubectl "$@"
}