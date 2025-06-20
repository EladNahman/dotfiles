#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/EladNahman/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$DOTFILES_DIR-backup"
ALIAS="alias dotfiles='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME"

echo "Downloading git..."
sudo apt update && sudo apt install -y git

echo "Cloning dotfiles repo..."
git clone --bare "$REPO_URL" "$DOTFILES_DIR"

function dotfiles {
	git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "Creating backup for conflicting dotfiles..."
mkdir -p "$BACKUP_DIR"
dotfiles checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read -r file; do
  mkdir -p "$(dirname "$BACKUP_DIR/$file")"
  mv "$HOME/$file" "$BACKUP_DIR/$file"
done

echo "Checking out dotfiles..."
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

echo "Adding alias to shell"
if ! grep -q "$ALIAS" "$HOME/.bashrc"; then
  echo "$ALIAS" >> "$HOME/.bashrc"
fi

echo "Installing apt packages..."
APT_PACKAGES=(
	git
	tmux
	neovim
	docker-ce
	docker-compose
	node
	nvm
	npm
	curl
	ripgrep
	libtree-sitter-dev
)
sudo apt install -y "${APT_PACKAGES[@]}"

echo "Setup complete!"
