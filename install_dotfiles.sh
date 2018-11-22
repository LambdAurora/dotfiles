#!/usr/bin/env zsh

echo "Installing dotfiles..."

# Get current dir
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install
echo "Installing .zshrc..."
ln -svf "$DOTFILES_DIR/.zshrc" ~
echo "Installing .lambdadotfiles/..."
ln -svf "$DOTFILES_DIR/.lambdadotfiles/" ~
echo "Installing oh-my-zsh files..."
mkdir -p ~/.oh-my-zsh/custom/themes
ln -svf "$DOTFILES_DIR/.oh-my-zsh/custom/themes/lambdaurora.zsh-theme" ~/.oh-my-zsh/custom/themes
echo "Installing .vimrc..."
ln -svf "$DOTFILES_DIR/.vimrc" ~
echo "Installing .vim files..."
mkdir -p ~/.vim/colors
ln -svf "$DOTFILES_DIR/.vim/colors/hybrid.vim" ~/.vim/colors
