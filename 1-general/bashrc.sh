# Main shell configuration entry point for dotfiles repo
# Sourced by ~/.bashrc and ~/.zshrc

# Find repo root in both Bash and Zsh
if [ -n "$ZSH_VERSION" ]; then
  CURRENT_SCRIPT="${(%):-%x}"
else
  CURRENT_SCRIPT="${BASH_SOURCE[0]}"
fi
REPO_DIR="$(cd "$(dirname "$CURRENT_SCRIPT")/.." && pwd)"

# --- Path Assurance for Interactive Shells ---
for dir in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/bin"; do
  if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
  fi
done

# --- General Settings ---
set -o vi

# --- Python & IPython Configuration ---
if [[ -f "$REPO_DIR/1-general/.pythonrc" ]]; then
  export PYTHONSTARTUP="$REPO_DIR/1-general/.pythonrc"
fi

if [[ -f "$REPO_DIR/1-general/ipython_config.py" ]]; then
  if [[ ! -L "$HOME/.ipython/profile_default/ipython_config.py" || "$(readlink "$HOME/.ipython/profile_default/ipython_config.py" 2>/dev/null)" != "$REPO_DIR/1-general/ipython_config.py" ]]; then
    mkdir -p "$HOME/.ipython/profile_default"
    ln -sfn "$REPO_DIR/1-general/ipython_config.py" "$HOME/.ipython/profile_default/ipython_config.py"
  fi
fi

# --- Aliases ---
# /usr/share/doc/lf/examples/lfcd.sh
lfcd () {
  # `command` is needed in case `lfcd` is aliased to `lf`
  cd "$(command lf -print-last-dir "$@")"
}
alias lf='lfcd'

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- Zsh Completion System Initialization ---
if [ -n "$ZSH_VERSION" ]; then
  if ! (( $+functions[compdef] )); then
    autoload -Uz compinit && compinit -C 2>/dev/null || true
  fi
  if ! (( $+functions[complete] )); then
    autoload -Uz bashcompinit && bashcompinit 2>/dev/null || true
  fi
fi

# --- Custom Prompt (Bash & Zsh) ---
if [[ -f "$REPO_DIR/1-general/.PS1.sh" ]]; then
  source "$REPO_DIR/1-general/.PS1.sh"
fi

# --- GCP & K8s Functions ---
if [[ -d "$REPO_DIR/3-gcp" ]]; then
  [[ -f "$REPO_DIR/3-gcp/gcp-set.sh" ]] && source "$REPO_DIR/3-gcp/gcp-set.sh"
  [[ -f "$REPO_DIR/3-gcp/k8s-set.sh" ]] && source "$REPO_DIR/3-gcp/k8s-set.sh"
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi
