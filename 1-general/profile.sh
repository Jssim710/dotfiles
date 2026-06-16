# Main profile entry point for dotfiles repo
# This file is sourced by ~/.profile. No manual action is required for this file itself.

# --- Hangul Configuration ---
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export QT_QPA_PLATFORM=xcb
if ! pgrep -f fcitx5 > /dev/null; then
    nohup fcitx5 -d > /dev/null 2>&1 &
fi

# --- Go Configuration ---
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# --- Rust Configuration ---
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
