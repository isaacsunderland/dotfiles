# bash kubectl completion.

if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
    _ensure_kubectl_cnpg_completion_helper
fi