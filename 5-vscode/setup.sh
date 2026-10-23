#!/bin/bash

# Target directory and file paths for VS Code on Linux
CONFIG_DIR="$HOME/.config/Code/User"
TARGET_FILE="$CONFIG_DIR/settings.json"
TASKS_TARGET_FILE="$CONFIG_DIR/tasks.json"

echo -e "\033[0;32mSetting up VS Code configuration...\033[0m"

# 1. Ensure directories exist
mkdir -p "$CONFIG_DIR"

# 2. Backup settings.json if CONFIG_DIR is a real directory and settings.json is not a link
if [[ ! -L "$CONFIG_DIR" && -f "$TARGET_FILE" && ! -L "$TARGET_FILE" ]]; then
    echo -e "\033[0;33mWarning: A physical file exists at $TARGET_FILE.\033[0m"
    read -p "Do you want to backup it? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TARGET_FILE" "${TARGET_FILE}.bak"
        echo -e "\033[0;33mOriginal settings.json backed up to ${TARGET_FILE}.bak\033[0m"
    fi
fi

# 3. Backup tasks.json if CONFIG_DIR is a real directory and tasks.json is not a link
if [[ ! -L "$CONFIG_DIR" && -f "$TASKS_TARGET_FILE" && ! -L "$TASKS_TARGET_FILE" ]]; then
    echo -e "\033[0;33mWarning: A physical file exists at $TASKS_TARGET_FILE.\033[0m"
    read -p "Do you want to backup it? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TASKS_TARGET_FILE" "${TASKS_TARGET_FILE}.bak"
        echo -e "\033[0;33mOriginal tasks.json backed up to ${TASKS_TARGET_FILE}.bak\033[0m"
    fi
fi

echo -e "\033[0;32mVS Code setup complete.\033[0m"
