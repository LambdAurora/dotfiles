#!/usr/bin/env zsh

echo "Installing dotfiles..."

# Get current dir
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install
echo "Installing .zshrc..."
ln -svf "$DOTFILES_DIR/.zshrc" ~
echo "Installing .lambdadotfiles/..."
ln -svf "$DOTFILES_DIR/.lambdadotfiles/" ~
