# Sourced by ../1-general/bashrc.sh

# --- gcloud Shell Completion (Zsh & Bash) ---
_setup_gcloud_completion() {
    if [ -n "$ZSH_VERSION" ]; then
        for inc in \
            "/usr/share/google-cloud-sdk/completion.zsh.inc" \
            "/usr/lib/google-cloud-sdk/completion.zsh.inc" \
            "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" \
            "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" \
            "$HOME/google-cloud-sdk/completion.zsh.inc"; do
            if [[ -f "$inc" ]]; then
                source "$inc" 2>/dev/null
                break
            fi
        done
        # Fix Zsh word-splitting and indexing in gcloud argcomplete
        if typeset -f _python_argcomplete >/dev/null; then
            _gcloud_python_argcomplete() {
                setopt localoptions shwordsplit noshglob
                _python_argcomplete "$@"
            }
            complete -o nospace -o default -F _gcloud_python_argcomplete "gcloud"
            complete -o nospace -o default -F _gcloud_python_argcomplete "gsutil"
        fi
    elif [ -n "$BASH_VERSION" ]; then
        for inc in \
            "/usr/share/google-cloud-sdk/completion.bash.inc" \
            "/usr/lib/google-cloud-sdk/completion.bash.inc" \
            "/etc/bash_completion.d/gcloud" \
            "$HOME/google-cloud-sdk/completion.bash.inc"; do
            if [[ -f "$inc" ]]; then
                source "$inc" 2>/dev/null
                break
            fi
        done
    fi
}
_setup_gcloud_completion

_update_gcp_vars() {
    local active_cfg="default"
    if [ -f "$HOME/.config/gcloud/active_config" ]; then
        active_cfg=$(tr -d '\r\n' < "$HOME/.config/gcloud/active_config")
    fi
    local cfg_file="$HOME/.config/gcloud/configurations/config_${active_cfg}"
    local raw_project=""
    local raw_account=""
    if [ -f "$cfg_file" ]; then
        raw_project=$(awk -F' = ' '/^project/ {print $2}' "$cfg_file" | tr -d ' ')
        raw_account=$(awk -F' = ' '/^account/ {print $2}' "$cfg_file" | tr -d ' ')
    fi
    [ -z "$raw_project" ] && raw_project=$(gcloud config get-value project 2>/dev/null)
    [ -z "$raw_account" ] && raw_account=$(gcloud config get-value account 2>/dev/null)

    export GCP_PROJECT="$raw_project"
    if echo "$raw_account" | grep -q "admin"; then
        export GCP_ROLE="admin"
        export GCP_ACCOUNT="admin@"
    else
        export GCP_ROLE="user"
        local user_prefix="${raw_account%%@*}"
        export GCP_ACCOUNT="${user_prefix:-$USER}@"
    fi
    export GCP_WORKSPACE_ACTIVE="true"
}

gssh() {
    if [ -z "$1" ]; then
        echo "Usage: gssh [INSTANCE_NAME] [--zone=ZONE] [OTHER_FLAGS]"
        return 1
    fi
    gcloud compute ssh "$1" --tunnel-through-iap --zone="asia-northeast3-a" "${@:2}"
}

gcp() {
    if ! command -v starship &> /dev/null; then
        echo -e "\033[0;31mError: Starship command not found. Please install it first.\033[0m"
        echo "You can install it by running: curl -sS https://starship.rs/install.sh | sh"
        return 1
    fi

    if [ -d "$HOME/.terraform/bin" ]; then
        if [[ ":$PATH:" != *":$HOME/.terraform/bin:"* ]]; then
            export PATH="$HOME/.terraform/bin:$PATH"
        fi
    fi

    _update_gcp_vars

    # Ensure Starship loads the correct dotfiles configuration
    local repo_root
    if [ -n "$ZSH_VERSION" ]; then
        repo_root="$(cd "$(dirname "${(%):-%x}")/.." && pwd)"
    else
        repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    fi
    if [[ -f "$repo_root/3-gcp/.config/starship.toml" ]]; then
        export STARSHIP_CONFIG="$repo_root/3-gcp/.config/starship.toml"
    fi

    # Initialize Starship for the active shell (only once to prevent recursive ZLE wrappers)
    if [ -n "$ZSH_VERSION" ]; then
        if ! declare -f prompt_starship_precmd >/dev/null && ! declare -f starship_precmd >/dev/null; then
            eval "$(starship init zsh)"
        fi
    elif [ -n "$BASH_VERSION" ]; then
        if ! declare -f starship_precmd >/dev/null; then
            eval "$(starship init bash)"
        fi
    fi

    echo -e "\033[0;32m[GCP Workspace Activated]\033[0m"
}

ungcp() {
    unset GCP_PROJECT GCP_ACCOUNT GCP_ROLE GCP_WORKSPACE_ACTIVE STARSHIP_KUBE_ENABLED STARSHIP_CONFIG

    # 1. Clean up Starship hooks completely based on shell
    if [ -n "$ZSH_VERSION" ]; then
        autoload -Uz add-zsh-hook 2>/dev/null || true
        add-zsh-hook -d precmd prompt_starship_precmd 2>/dev/null || true
        add-zsh-hook -d preexec prompt_starship_preexec 2>/dev/null || true
        precmd_functions=(${precmd_functions:#*starship*})
        preexec_functions=(${preexec_functions:#*starship*})
        if [[ "${widgets[zle-keymap-select]}" == *"starship"* ]]; then
            zle -D zle-keymap-select 2>/dev/null || true
        fi
        unfunction prompt_starship_precmd 2>/dev/null || true
        unfunction prompt_starship_preexec 2>/dev/null || true
        unfunction starship_zle-keymap-select 2>/dev/null || true
        unfunction starship_zle-keymap-select-wrapped 2>/dev/null || true
        unset RPROMPT
    elif [ -n "$BASH_VERSION" ]; then
        unset PROMPT_COMMAND
    fi

    # 2. Restore default prompt cleanly
    if declare -f _set_default_prompt > /dev/null; then
        _set_default_prompt
    elif declare -f _set_default_ps1 > /dev/null; then
        _set_default_ps1
    elif [ -f "$REPO_DIR/1-general/.PS1.sh" ]; then
        source "$REPO_DIR/1-general/.PS1.sh"
    else
        export PS1='\u@\h:\w\$ '
    fi

    # 3. Clean up Terraform PATH
    if [[ ":$PATH:" == *":$HOME/.terraform/bin:"* ]]; then
        export PATH=$(echo "$PATH" | sed -e "s|$HOME/.terraform/bin:||g" -e "s|:$HOME/.terraform/bin||g" -e "s|^$HOME/.terraform/bin$||g")
    fi

    echo -e "\033[0;33m[GCP Workspace Deactivated. Original prompt restored]\033[0m"
}
