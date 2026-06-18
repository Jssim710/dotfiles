#!/bin/bash

# Master setup script for dotfiles using GNU Stow
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "\033[0;32mStarting dotfiles setup with GNU Stow...\033[0m"

# 1. Check for GNU Stow
if ! command -v stow &> /dev/null; then
    echo -e "\033[0;33mGNU Stow not found. Attempting to install...\033[0m"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y stow
        elif command -v yum &> /dev/null; then
            sudo yum install -y stow
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm stow
        else
            echo -e "\033[0;31mError: Could not determine package manager. Please install 'stow' manually.\033[0m"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install stow
        else
            echo -e "\033[0;31mError: Homebrew not found. Please install 'stow' manually.\033[0m"
            exit 1
        fi
    else
        echo -e "\033[0;31mError: Unsupported OS. Please install 'stow' manually.\033[0m"
        exit 1
    fi
fi

# 2. Run Stow
echo -e "\033[0;32mLinking configuration files with Stow...\033[0m"
cd "$REPO_ROOT"

# Clean up potential failed Stow attempts (empty folders in target)
rm -rf ~/.config/Code/User ~/.config/lf

# Use --adopt to link existing files and update them to repo versions if they differ.
stow --adopt -v -t "$HOME" 1-general 2-vim 3-gcp 4-git 5-vscode

# 3. Run individual setup scripts for post-install logic
echo -e "\033[0;32mRunning post-install scripts...\033[0m"

# Core Shell Configurations (Injections)
echo -e "\033[0;36m--- Shell Injections ---\033[0m"
[[ -f "$REPO_ROOT/1-general/profile-set.sh" ]] && bash "$REPO_ROOT/1-general/profile-set.sh"
[[ -f "$REPO_ROOT/1-general/bashrc-set.sh" ]] && bash "$REPO_ROOT/1-general/bashrc-set.sh"

# Tool specific setup (Plugins, binaries, etc.)
echo -e "\033[0;36m--- Tool Specific Setup ---\033[0m"
[[ -f "$REPO_ROOT/2-vim/vim-set.sh" ]] && bash "$REPO_ROOT/2-vim/vim-set.sh"
[[ -f "$REPO_ROOT/3-gcp/setup.sh" ]] && bash "$REPO_ROOT/3-gcp/setup.sh"
[[ -f "$REPO_ROOT/4-git/setup.sh" ]] && bash "$REPO_ROOT/4-git/setup.sh"
[[ -f "$REPO_ROOT/5-vscode/setup.sh" ]] && bash "$REPO_ROOT/5-vscode/setup.sh"

echo -e "\033[0;32mFull setup complete!\033[0m"
echo "To apply changes to your current session, run:"
echo "  source ~/.profile"
echo "  source ~/.bashrc"
