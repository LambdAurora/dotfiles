#!/usr/bin/env zsh

echo "Installing dotfiles..."

# Get current dir
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Installation.

echo "Installing common dotfiles..."
mkdir -p ~/.config
ln -svf "$DOTFILES_DIR/.lambdadotfiles/" ~

# Install configuration files for the shell.
echo "Installing zsh configuration files..."
ln -svf "$DOTFILES_DIR/.zshrc" ~
mkdir -p ~/.oh-my-zsh/custom/themes
ln -svf "$DOTFILES_DIR/.oh-my-zsh/custom/themes/lambdaurora.zsh-theme" ~/.oh-my-zsh/custom/themes

# Install configuration files for vim.
echo "Installing vim configuration files..."
ln -svf "$DOTFILES_DIR/.vimrc" ~
mkdir -p ~/.vim/colors
ln -svf "$DOTFILES_DIR/.vim/colors/hybrid.vim" ~/.vim/colors

# Install configuration files for i3.
echo "Installing i3 configuration files..."
mkdir -p ~/.config/i3
ln -svf "$DOTFILES_DIR/.config/i3/config" ~/.config/i3

# Install configuration files for polybar.
mkdir -p ~/.config/polybar
ln -svf "$DOTFILES_DIR/.config/polybar/config" ~/.config/polybar
ln -svf "$DOTFILES_DIR/.config/polybar/launch.sh" ~/.config/polybar
