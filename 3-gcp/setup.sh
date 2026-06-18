#!/bin/bash

# Target directory for Starship config
CONFIG_DIR="$HOME/.config"
TARGET_FILE="$CONFIG_DIR/starship.toml"

echo -e "\033[0;32mSetting up GCP & Starship configuration...\033[0m"

# 1. Ensure ~/.config exists
mkdir -p "$CONFIG_DIR"

# 2. Backup existing starship.toml if it's not a link
if [[ -f "$TARGET_FILE" && ! -L "$TARGET_FILE" ]]; then
    echo -e "\033[0;33mWarning: A physical file exists at $TARGET_FILE.\033[0m"
    read -p "Do you want to backup it? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TARGET_FILE" "${TARGET_FILE}.bak"
        echo -e "\033[0;33mOriginal file backed up to ${TARGET_FILE}.bak\033[0m"
    fi
fi

# 3. Install Starship if not already installed
if ! command -v starship &> /dev/null; then
    echo -e "\033[0;32mStarship not found. Installing...\033[0m"
    curl -sS https://starship.rs/install.sh | sh
else
    echo -e "\033[0;32mStarship is already installed: $(starship --version | head -n 1)\033[0m"
fi

echo -e "\033[0;32mGCP Setup Complete.\033[0m"
