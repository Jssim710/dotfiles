#!/bin/bash

# Path to the symlink created by Stow (or fallback to repo file)
if [[ -f "$HOME/.gitconfig_local" || -L "$HOME/.gitconfig_local" ]]; then
    CONFIG_PATH="$HOME/.gitconfig_local"
else
    CONFIG_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.gitconfig_local"
fi

# Add it to the user's global git config as an include
git config --global include.path "$CONFIG_PATH"

echo -e "\033[0;32mGit global include set to $CONFIG_PATH.\033[0m"
