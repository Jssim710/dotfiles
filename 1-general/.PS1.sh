#!/bin/bash

# Define color variables for the prompt
C_USER='\[\033[01;32m\]'  # User: Bold Green
C_HOST='\[\033[01;33m\]'  # Host: Bold Yellow
C_PATH='\[\033[01;34m\]'  # Path: Bold Blue
C_GIT='\[\033[01;36m\]'   # Git: Bold Cyan
C_RESET='\[\033[00m\]'     # Reset color to default

# Source git-sh-prompt if it exists
for f in /usr/lib/git-core/git-sh-prompt /usr/share/git/completion/git-sh-prompt; do
  if [[ -f "$f" ]]; then
    source "$f"
    break
  fi
done

# Configure git prompt features
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

# Set the PS1 prompt string.
# The format will be: user@host:path (branch)$
# \[\e]0;\u@\h: \w\a\] sets the terminal window title.
# ${debian_chroot:+($debian_chroot)} preserves any existing chroot indicator.
if type __git_ps1 &>/dev/null; then
  PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}${C_USER}\u${C_RESET}@${C_HOST}\h${C_RESET}:${C_PATH}\w${C_RESET}${C_GIT}\$(__git_ps1)${C_RESET}\$ "
else
  PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}${C_USER}\u${C_RESET}@${C_HOST}\h${C_RESET}:${C_PATH}\w${C_RESET}\$ "
fi

# Unset variables from the default .bashrc that control color prompts,
# as we are now explicitly managing colors in the PS1 variable above.
unset color_prompt force_color_prompt
