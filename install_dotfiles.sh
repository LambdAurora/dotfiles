#!/usr/bin/env zsh

echo "Installing dotfiles..."

# Get current dir
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
alias tmp_ln="ln -sf"
alias tmp_dir_ln="ln -sfd"
for param in "$*"
do
	if [[ $param == "--verbose" ]] || [[ $param == "-v" ]]
	then
		alias tmp_ln="ln -svf"
        alias tmp_dir_ln="ln -svfd"
	fi
done

## Installation.

echo "Installing common dotfiles..."
mkdir -p ~/.config
tmp_ln "$DOTFILES_DIR/.lambdadotfiles/" ~

# Install configuration files for the shell.
echo "Installing zsh configuration files..."
tmp_ln "$DOTFILES_DIR/.zshrc" ~
mkdir -p ~/.oh-my-zsh/custom/themes
tmp_ln "$DOTFILES_DIR/.oh-my-zsh/custom/themes/lambdaurora.zsh-theme" ~/.oh-my-zsh/custom/themes

# Install configuration files for vim.
echo "Installing vim configuration files..."
tmp_ln "$DOTFILES_DIR/.vimrc" ~
mkdir -p ~/.vim/colors
tmp_ln "$DOTFILES_DIR/.vim/colors/hybrid.vim" ~/.vim/colors
mkdir -p ~/.vim/autoload
tmp_ln "$DOTFILES_DIR/.vim/autoload/pathogen.vim" ~/.vim/autoload
mkdir -p ~/.vim/bundle
tmp_dir_ln "$DOTFILES_DIR/.vim/bundle/nerdtree/" ~/.vim/bundle

# Install configuration files for Compton.
echo "Installing Compton configuration files..."
mkdir -p ~/.config/compton
tmp_ln "$DOTFILES_DIR/.config/compton/config" ~/.config/compton

# Install configuration files for i3.
echo "Installing i3 configuration files..."
mkdir -p ~/.config/i3
tmp_ln "$DOTFILES_DIR/.config/i3/config" ~/.config/i3

# Install configuration files for polybar.
mkdir -p ~/.config/polybar
tmp_ln "$DOTFILES_DIR/.config/polybar/config" ~/.config/polybar
tmp_ln "$DOTFILES_DIR/.config/polybar/launch.sh" ~/.config/polybar

unalias tmp_ln
