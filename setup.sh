#!/bin/bash

# Master setup script for dotfiles
# This script runs all individual setup and injection scripts in the subdirectories.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting full dotfiles setup..."

# 1. Core Shell Configurations (Injections)
echo "--- Setting up Shell (Bash & Profile) ---"
[[ -f "$REPO_ROOT/1-general/profile-set.sh" ]] && bash "$REPO_ROOT/1-general/profile-set.sh"
[[ -f "$REPO_ROOT/1-general/bashrc-set.sh" ]] && bash "$REPO_ROOT/1-general/bashrc-set.sh"

# 2. Tool Configurations (Symlinks & Installs)
echo "--- Setting up Tools ---"

# lf
LF_SOURCE="$REPO_ROOT/1-general/lfrc"
LF_TARGET="$HOME/.config/lf/lfrc"
if [[ -f "$LF_SOURCE" ]]; then
    echo "[lf]"
    mkdir -p "$HOME/.config/lf"
    if [[ -L "$LF_TARGET" ]]; then
        ln -sf "$LF_SOURCE" "$LF_TARGET"
    elif [[ -f "$LF_TARGET" ]]; then
        read -p "Backup and replace existing lfrc? [y/N] " confirm
        if [[ ${confirm,,} =~ ^(yes|y)$ ]]; then
            mv "$LF_TARGET" "${LF_TARGET}.bak"
            ln -s "$LF_SOURCE" "$LF_TARGET"
        fi
    else
        ln -s "$LF_SOURCE" "$LF_TARGET"
    fi
fi

# Vim
if [[ -f "$REPO_ROOT/2-vim/vim-set.sh" ]]; then
    echo "[Vim]"
    bash "$REPO_ROOT/2-vim/vim-set.sh"
fi

# GCP / Starship
if [[ -f "$REPO_ROOT/3-gcp/setup.sh" ]]; then
    echo "[GCP/Starship]"
    bash "$REPO_ROOT/3-gcp/setup.sh"
fi

# Git
if [[ -f "$REPO_ROOT/4-git/setup.sh" ]]; then
    echo "[Git]"
    bash "$REPO_ROOT/4-git/setup.sh"
fi

# VSCode
if [[ -f "$REPO_ROOT/5-vscode/setup.sh" ]]; then
    echo "[VSCode]"
    bash "$REPO_ROOT/5-vscode/setup.sh"
fi

echo "Full setup complete!"
echo "To apply changes to your current session, run:"
echo "  source ~/.profile"
echo "  source ~/.bashrc"
