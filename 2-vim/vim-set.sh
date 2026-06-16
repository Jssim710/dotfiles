#!/bin/bash

# Get the absolute path to the vimrc in this repo
REPO_VIMRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/vimrc"

# Target file
VIMRC_FILE="$HOME/.vimrc"

# 1. Backup existing .vimrc if it's not a link
if [[ -f "$VIMRC_FILE" && ! -L "$VIMRC_FILE" ]]; then
  echo "Backing up existing $VIMRC_FILE to $VIMRC_FILE.bak..."
  mv "$VIMRC_FILE" "$VIMRC_FILE.bak"
fi

# 2. Create symbolic link
echo "Creating symbolic link for $VIMRC_FILE..."
ln -sf "$REPO_VIMRC" "$VIMRC_FILE"

# 3. Install vim-plug if it doesn't exist
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  echo "Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 4. Install plugins
echo "Installing Vim plugins..."
vim +PlugInstall +qall

echo "Vim configuration set up successfully."
