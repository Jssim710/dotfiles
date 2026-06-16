#!/bin/bash

# Get the absolute path of the local gitconfig file
# This works whether you run it from project root or inside 4-git/
CONFIG_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/gitconfig"

# Add it to the user's global git config as an include
git config --global include.path "$CONFIG_PATH"

echo "Git alias 'tree' has been added to your global config via an 'include'."
echo "You can now use 'git tree' anywhere in your terminal."
