#!/bin/bash

# Target directory for VSCode config
CONFIG_DIR="$HOME/.config/Code/User"
TARGET_FILE="$CONFIG_DIR/settings.json"
TASKS_TARGET_FILE="$CONFIG_DIR/tasks.json"

echo -e "\033[0;32mChecking VSCode configuration...\033[0m"

# 1. Ensure directories exist
mkdir -p "$CONFIG_DIR"

# 2. Backup settings.json if it's not a link
if [[ -f "$TARGET_FILE" && ! -L "$TARGET_FILE" ]]; then
    echo -e "\033[0;33mWarning: A physical file exists at $TARGET_FILE.\033[0m"
    read -p "Do you want to backup it? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TARGET_FILE" "${TARGET_FILE}.bak"
        echo -e "\033[0;33mOriginal settings.json backed up to ${TARGET_FILE}.bak\033[0m"
    fi
fi

# 3. Backup tasks.json if it's not a link
if [[ -f "$TASKS_TARGET_FILE" && ! -L "$TASKS_TARGET_FILE" ]]; then
    echo -e "\033[0;33mWarning: A physical file exists at $TASKS_TARGET_FILE.\033[0m"
    read -p "Do you want to backup it? [y/N] " confirm
    if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
        mv "$TASKS_TARGET_FILE" "${TASKS_TARGET_FILE}.bak"
        echo -e "\033[0;33mOriginal tasks.json backed up to ${TASKS_TARGET_FILE}.bak\033[0m"
    fi
fi

echo -e "\033[0;32mVSCode Setup Check Complete.\033[0m"
