#!/bin/bash

# Get the absolute path to the main profile.sh in this repo
REPO_PROFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/profile.sh"

# Target file
PROFILE_FILE="$HOME/.profile"

# Marker strings for modular injection
MARKER_START="# >>> DOTFILES REPO (Profile) >>>"
MARKER_END="# <<< DOTFILES REPO (Profile) <<<"
INJECTION="[[ -f \"$REPO_PROFILE\" ]] && source \"$REPO_PROFILE\""

# 1. Clean up existing markered block (for idempotency)
if grep -q "$MARKER_START" "$PROFILE_FILE" 2>/dev/null; then
  echo "Updating existing dotfiles block in $PROFILE_FILE..."
  sed -i "/$MARKER_START/,/$MARKER_END/d" "$PROFILE_FILE"
else
  echo "Injecting modular loader into $PROFILE_FILE..."
fi

# 2. Inject the markered block
{
  echo ""
  echo "$MARKER_START"
  echo "$INJECTION"
  echo "$MARKER_END"
} >> "$PROFILE_FILE"

echo "Done. Please log out and log back in, or run 'source ~/.profile'."
