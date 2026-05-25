#!/bin/bash

# Define color variables for the prompt
C_USER='\[\033[01;32m\]'  # User: Bold Green
C_HOST='\[\033[01;33m\]'  # Host: Bold Yellow
C_PATH='\[\033[01;34m\]'  # Path: Bold Blue
C_RESET='\[\033[00m\]'     # Reset color to default

# Set the PS1 prompt string.
# The format will be: user@host:path$
# \[\e]0;\u@\h: \w\a\] sets the terminal window title.
# ${debian_chroot:+($debian_chroot)} preserves any existing chroot indicator.
PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}${C_USER}\u${C_RESET}@${C_HOST}\h${C_RESET}:${C_PATH}\w${C_RESET}\$ "

# Unset variables from the default .bashrc that control color prompts,
# as we are now explicitly managing colors in the PS1 variable above.
unset color_prompt force_color_prompt
