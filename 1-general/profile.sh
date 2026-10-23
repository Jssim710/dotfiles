# Main profile entry point for dotfiles repo
# Sourced by ~/.profile

if [ -n "$ZSH_VERSION" ]; then
  CURRENT_SCRIPT="${(%):-%x}"
else
  CURRENT_SCRIPT="${BASH_SOURCE[0]}"
fi
REPO_DIR="$(cd "$(dirname "$CURRENT_SCRIPT")/.." && pwd)"

# --- Path setup (login shell environment) ---
for dir in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/bin" "$HOME/.go/bin"; do
  if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
  fi
done

# --- Go Configuration ---
export GOPATH="$HOME/.go"

# --- Rust Configuration ---
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
