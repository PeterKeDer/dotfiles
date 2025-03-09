#!/usr/bin/env bash

# NOTE: Run in the base dotfiles directory

set -euxo pipefail

stow .

# Include custom gitconfig
GIT_CONFIG_PATH="$HOME/.gitconfig"
if ! grep -Fqs "PeterKeDer/dotfiles" "$GIT_CONFIG_PATH"; then
  echo "" >> "$GIT_CONFIG_PATH"
  cat >> "$GIT_CONFIG_PATH" <<EOT
# Inserted by PeterKeDer/dotfiles
[include]
	path = $HOME/.config/git/.gitconfig
EOT
fi


