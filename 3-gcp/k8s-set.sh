# sourced by ../1-general/bashrc.sh

k8s() {
    # Ensure gcp info is loaded first
    if [ -z "$GCP_PROJECT" ]; then _update_gcp_vars; fi

    export STARSHIP_KUBE_ENABLED="true"
    export STARSHIP_COMMAND_TIMEOUT=2000
    alias k='kubectl'

    # Requirement: Strip domain for K8s mode
    export GCP_ACCOUNT="${GCP_ACCOUNT%%@*}"

    source <(kubectl completion bash)
    complete -F __start_kubectl k
    echo "☸️  Kubernetes Mode Activated."
}

unk8s() {
    unset STARSHIP_KUBE_ENABLED
    unset STARSHIP_COMMAND_TIMEOUT
    unalias k 2>/dev/null
    _update_gcp_vars # Restore full email and role
    echo "🚫 Back to GCP Standard Mode."
}
