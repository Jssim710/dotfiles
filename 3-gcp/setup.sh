#!/bin/bash

# Get the absolute path to this directory
GCP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory for Starship config
CONFIG_DIR="$HOME/.config"
TARGET_FILE="$CONFIG_DIR/starship.toml"
SOURCE_FILE="$GCP_DIR/starship.toml"

echo "Setting up GCP & Starship configuration..."

# 1. Ensure ~/.config exists
mkdir -p "$CONFIG_DIR"

# 2. Symlink starship.toml
if [[ -L "$TARGET_FILE" ]]; then
    echo "Symlink for starship.toml already exists. Updating..."
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
elif [[ -f "$TARGET_FILE" ]]; then
    echo "Warning: A physical file exists at $TARGET_FILE."
    read -p "Do you want to backup and replace it with a symlink? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TARGET_FILE" "${TARGET_FILE}.bak"
        ln -s "$SOURCE_FILE" "$TARGET_FILE"
        echo "Original file backed up to ${TARGET_FILE}.bak"
    fi
else
    echo "Creating symlink: $TARGET_FILE -> $SOURCE_FILE"
    ln -s "$SOURCE_FILE" "$TARGET_FILE"
fi

echo "GCP Setup Complete."
