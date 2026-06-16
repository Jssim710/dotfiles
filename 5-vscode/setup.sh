#!/bin/bash

# Get the absolute path to this directory
VSCODE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory for VSCode config
CONFIG_DIR="$HOME/.config/Code/User"
TARGET_FILE="$CONFIG_DIR/settings.json"
SOURCE_FILE="$VSCODE_DIR/settings.json"
TASKS_TARGET_FILE="$CONFIG_DIR/tasks.json"
TASKS_SOURCE_FILE="$VSCODE_DIR/tasks.json"

echo "Setting up VSCode configuration..."

# 1. Ensure directories exist
mkdir -p "$CONFIG_DIR"

# 2. Symlink settings.json
if [[ -L "$TARGET_FILE" ]]; then
    echo "Symlink for settings.json already exists. Updating..."
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
elif [[ -f "$TARGET_FILE" ]]; then
    echo "Warning: A physical file exists at $TARGET_FILE."
    read -p "Do you want to backup and replace it with a symlink for settings.json? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TARGET_FILE" "${TARGET_FILE}.bak"
        ln -s "$SOURCE_FILE" "$TARGET_FILE"
        echo "Original settings.json backed up to ${TARGET_FILE}.bak"
    fi
else
    echo "Creating symlink: $TARGET_FILE -> $SOURCE_FILE"
    ln -s "$SOURCE_FILE" "$TARGET_FILE"
fi

# 3. Symlink tasks.json
if [[ -L "$TASKS_TARGET_FILE" ]]; then
    echo "Symlink for tasks.json already exists. Updating..."
    ln -sf "$TASKS_SOURCE_FILE" "$TASKS_TARGET_FILE"
elif [[ -f "$TASKS_TARGET_FILE" ]]; then
    echo "Warning: A physical file exists at $TASKS_TARGET_FILE."
    read -p "Do you want to backup and replace it with a symlink for tasks.json? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TASKS_TARGET_FILE" "${TASKS_TARGET_FILE}.bak"
        ln -s "$TASKS_SOURCE_FILE" "$TASKS_TARGET_FILE"
        echo "Original tasks.json backed up to ${TASKS_TARGET_FILE}.bak"
    fi
else
    echo "Creating symlink: $TASKS_TARGET_FILE -> $TASKS_SOURCE_FILE"
    ln -s "$TASKS_SOURCE_FILE" "$TASKS_TARGET_FILE"
fi

echo "VSCode Setup Complete."
