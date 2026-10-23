# Sourced by ../1-general/bashrc.sh

k8s() {
    if [ -z "$GCP_PROJECT" ]; then _update_gcp_vars; fi
    export STARSHIP_KUBE_ENABLED="true"
    export STARSHIP_COMMAND_TIMEOUT=2000
    alias k='kubectl'

    # Shell-specific kubectl completion
    if [ -n "$ZSH_VERSION" ]; then
        source <(kubectl completion zsh 2>/dev/null)
        compdef k=kubectl 2>/dev/null
    elif [ -n "$BASH_VERSION" ]; then
        source <(kubectl completion bash 2>/dev/null)
        complete -F __start_kubectl k 2>/dev/null
    fi

    echo -e "\033[0;36m[Kubernetes Mode Activated]\033[0m"
}

unk8s() {
    unset STARSHIP_KUBE_ENABLED
    unset STARSHIP_COMMAND_TIMEOUT
    unalias k 2>/dev/null
    complete -r k 2>/dev/null
    _update_gcp_vars
    echo -e "\033[0;33m[Back to GCP Standard Mode]\033[0m"
}
