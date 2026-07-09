# ~/.zprofile — managed by ~/dotfiles (symlinked)

# Homebrew (Apple Silicon). Falls back to Intel path for old machines.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$PATH:$HOME/.local/bin"
