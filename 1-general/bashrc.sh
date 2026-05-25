# Main bashrc entry point for dotfiles repo
# This file is sourced by ~/.bashrc. No manual action is required for this file itself.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- General Settings ---
# set vi shell option
set -o vi

# --- Python Configuration ---
if [[ -f "$REPO_DIR/1-general/pythonrc" ]]; then
  export PYTHONSTARTUP="$REPO_DIR/1-general/pythonrc"
fi

# --- Aliases ---
# /usr/share/doc/lf/examples/lfcd.sh
lfcd () {
  # `command` is needed in case `lfcd` is aliased to `lf`
  cd "$(command lf -print-last-dir "$@")"
}
alias lf='lfcd'

# basic alias
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- Custom PS1 ---
if [[ -f "$REPO_DIR/1-general/PS1.sh" ]]; then
  source "$REPO_DIR/1-general/PS1.sh"
fi

# --- GCP & K8s Functions ---
if [[ -d "$REPO_DIR/3-gcp" ]]; then
  [[ -f "$REPO_DIR/3-gcp/gcp-set.sh" ]] && source "$REPO_DIR/3-gcp/gcp-set.sh"
  [[ -f "$REPO_DIR/3-gcp/k8s-set.sh" ]] && source "$REPO_DIR/3-gcp/k8s-set.sh"
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# --- Optional Private Extensions ---
# Look for a sibling directory for private or work-specific configurations
PRIVATE_INTERNAL="$REPO_DIR/../google/google-internal.sh"
if [[ -f "$PRIVATE_INTERNAL" ]]; then
  source "$PRIVATE_INTERNAL"
fi
