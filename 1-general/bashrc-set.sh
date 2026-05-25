#!/bin/bash

# Get the absolute path to the main bashrc.sh in this repo
REPO_BASHRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bashrc.sh"

# Target file
BASHRC_FILE="$HOME/.bashrc"

# Marker strings for modular injection
MARKER_START="# >>> DOTFILES REPO >>>"
MARKER_END="# <<< DOTFILES REPO <<<"
INJECTION="[[ -f \"$REPO_BASHRC\" ]] && source \"$REPO_BASHRC\""

# 1. Clean up existing markered block (for idempotency)
if grep -q "$MARKER_START" "$BASHRC_FILE" 2>/dev/null; then
  echo "Updating existing dotfiles block in $BASHRC_FILE..."
  sed -i "/$MARKER_START/,/$MARKER_END/d" "$BASHRC_FILE"
else
  echo "Injecting modular loader into $BASHRC_FILE..."
fi

# 2. Inject the markered block
{
  echo ""
  echo "$MARKER_START"
  echo "$INJECTION"
  echo "$MARKER_END"
} >> "$BASHRC_FILE"

echo "Done. Please restart your shell or run 'source ~/.bashrc'."
