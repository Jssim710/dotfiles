#!/bin/bash

# Get the absolute path to the main shell config in this repo
REPO_BASHRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bashrc.sh"

# Script to inject the dotfiles loader into ~/.zshrc
ZSHRC_FILE="$HOME/.zshrc"
MARKER_START="# >>> DOTFILES REPO >>>"
MARKER_END="# <<< DOTFILES REPO <<<"

# Clean up existing block if present
if grep -q "$MARKER_START" "$ZSHRC_FILE" 2>/dev/null; then
  sed -i "/$MARKER_START/,/$MARKER_END/d" "$ZSHRC_FILE"
fi

# Inject the new block
cat >> "$ZSHRC_FILE" <<EOF_OUTER

# >>> DOTFILES REPO >>>
# Guard: only run inside Zsh (prevents errors if sourced from Bash)
if [ -z "\$ZSH_VERSION" ]; then
  return 0 2>/dev/null || exit 0
fi

# 1. Enable completion system and Bash completion compatibility
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# 2. Main dotfiles loader
[[ -f "$REPO_BASHRC" ]] && source "$REPO_BASHRC"

# 3. Zsh Interactive UI Options
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
# <<< DOTFILES REPO <<<
EOF_OUTER

echo -e "\033[0;32mZshrc injection complete.\033[0m"
