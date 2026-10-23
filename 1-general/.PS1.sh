# Git Prompt Status Indicators (*: unstaged, +: staged, $: stash, %: untracked)
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
unset GIT_PS1_SHOWUPSTREAM

# Load git prompt helper if available
if ! type __git_ps1 &>/dev/null; then
  for f in /usr/lib/git-core/git-sh-prompt /usr/share/git/completion/git-sh-prompt /etc/bash_completion.d/git-prompt; do
    if [[ -f "$f" ]]; then
      source "$f"
      break
    fi
  done
fi

# --- VCS Info Helper (Git: Yellow (branch *+$%)) ---
_get_vcs_info() {
  if type __git_ps1 &>/dev/null; then
    local git_str
    git_str=$(__git_ps1 " (%s)")
    if [[ -n "$git_str" ]]; then
      if [ -n "$ZSH_VERSION" ]; then
        echo "%B%F{yellow}${git_str}%f%b"
      elif [ -n "$BASH_VERSION" ]; then
        local C_YELLOW=$'\001\033[01;33m\002'
        local C_RESET=$'\001\033[00m\002'
        echo "${C_YELLOW}${git_str}${C_RESET}"
      fi
      return
    fi
  elif [ -n "$ZSH_VERSION" ]; then
    if [[ -n "${vcs_info_msg_0_}" ]]; then
      echo "${vcs_info_msg_0_}"
      return
    fi
  fi
}

# --- Debian-style Prompt Configuration with Git Support (Bash & Zsh) ---
_set_default_prompt() {
  if [ -n "$ZSH_VERSION" ]; then
    setopt prompt_subst
    autoload -Uz vcs_info 2>/dev/null || true
    zstyle ':vcs_info:*' enable git 2>/dev/null || true
    zstyle ':vcs_info:git:*' check-for-changes true 2>/dev/null || true
    zstyle ':vcs_info:git:*' unstagedstr '*' 2>/dev/null || true
    zstyle ':vcs_info:git:*' stagedstr '+' 2>/dev/null || true
    zstyle ':vcs_info:git:*' formats ' %B%F{yellow}(%b%u%c)%f%b' 2>/dev/null || true

    if [[ ! " ${precmd_functions[*]} " =~ " vcs_info " ]]; then
      precmd_functions+=(vcs_info)
    fi

    export PROMPT='%B%F{green}%n@%m%f%b:%B%F{blue}%~%f%b$(_get_vcs_info)%# '
    export PS1="$PROMPT"

  elif [ -n "$BASH_VERSION" ]; then
    local C_USER='\[\033[01;32m\]' # Bold Green
    local C_PATH='\[\033[01;34m\]' # Bold Blue
    local C_RESET='\[\033[00m\]'

    export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}${C_USER}\u@\h${C_RESET}:${C_PATH}\w${C_RESET}\$(_get_vcs_info)\$ "
  fi
}

_set_default_ps1() {
  _set_default_prompt
}

_set_default_prompt
unset color_prompt force_color_prompt
