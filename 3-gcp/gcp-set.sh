# sourced by ../1-general/bashrc.sh

_update_gcp_vars() {
    # 1. Get the current active project and account explicitly
    export GCP_PROJECT=$(gcloud config get-value project 2>/dev/null)
    export GCP_ACCOUNT=$(gcloud config get-value account 2>/dev/null)

    # 2. Check if the active account contains 'admin'
    # Use grep -q for a more robust check
    if echo "$GCP_ACCOUNT" | grep -q "admin"; then
        export GCP_ROLE="admin"
    else
        export GCP_ROLE="user"
    fi
}

gcp() {
    gssh() {
        if [ -z "$1" ]; then
            echo "Usage: gssh [INSTANCE_NAME] [--zone=ZONE] [OTHER_FLAGS]"
            return 1
        fi
        # --tunnel-through-iap is always used. 
        # --zone=asia-northeast3-a is the default, but can be overridden by passing another --zone flag in arguments.
        gcloud compute ssh "$1" --tunnel-through-iap --zone="asia-northeast3-a" "${@:2}"
    }

    # Initialize Starship if not already active
    if ! declare -f starship_precmd > /dev/null; then
        eval "$(starship init bash)"
    fi

    # Add ~/.terraform/bin to PATH if it exists and is not already there
    if [ -d "$HOME/.terraform/bin" ]; then
        if [[ ":$PATH:" != *":$HOME/.terraform/bin:"* ]]; then
            export PATH="$HOME/.terraform/bin:$PATH"
        fi
    fi

    _update_gcp_vars
    export PROMPT_COMMAND="starship_precmd"
    echo "☁️  GCP Workspace Activated."
}

ungcp() {
    # 1. Clear all GCP/K8s related variables
    unset GCP_PROJECT GCP_ACCOUNT GCP_ROLE STARSHIP_KUBE_ENABLED

    # 2. UNSET PROMPT_COMMAND (This is the key to disabling Starship)
    unset PROMPT_COMMAND

    # 3. Restore original PS1 by sourcing your backup script
    if [ -f "$REPO_DIR/1-general/PS1.sh" ]; then
        source "$REPO_DIR/1-general/PS1.sh"
    else
        # Fallback if .PS1.sh is missing
        export PS1='\u@\h:\w\$ '
    fi

    # 4. Cleanup PATH: remove ~/.terraform/bin
    if [[ ":$PATH:" == *":$HOME/.terraform/bin:"* ]]; then
        export PATH=$(echo "$PATH" | sed -e "s|$HOME/.terraform/bin:||g" -e "s|:$HOME/.terraform/bin||g" -e "s|^$HOME/.terraform/bin$||g")
    fi

    # 5. Cleanup aliases and functions
    unset -f gssh 2>/dev/null

    echo "🚫 GCP Workspace Deactivated. Original PS1 restored."
}
