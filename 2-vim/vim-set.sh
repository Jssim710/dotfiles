#!/bin/bash

# Target file
VIMRC_FILE="$HOME/.vimrc"

# 1. Backup existing .vimrc if it's not a link
if [[ -f "$VIMRC_FILE" && ! -L "$VIMRC_FILE" ]]; then
  echo -e "\033[0;33mBacking up existing $VIMRC_FILE to $VIMRC_FILE.bak...\033[0m"
  mv "$VIMRC_FILE" "$VIMRC_FILE.bak"
fi

# 2. Install vim-plug if it doesn't exist
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  echo -e "\033[0;32mInstalling vim-plug...\033[0m"
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 3. Install plugins
echo -e "\033[0;32mInstalling Vim plugins...\033[0m"
vim +PlugInstall +qall

echo -e "\033[0;32mVim configuration set up successfully.\033[0m"
