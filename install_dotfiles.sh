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
mkdir -p ~/.config/autostart-scripts
tmp_ln "$DOTFILES_DIR/.config/redshift.conf" ~/.config
tmp_ln "$DOTFILES_DIR/.lambdadotfiles/" ~
echo "#!/usr/bin/env zsh\n" > "$DOTFILES_DIR/.lambdadotfiles/startup/local/local.sh"
chmod +x "$DOTFILES_DIR/.lambdadotfiles/startup/local/local.sh"
tmp_ln -T "$DOTFILES_DIR/wallpapers/" ~/.wallpapers
tmp_ln "$DOTFILES_DIR/.xprofile" ~

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
tmp_dir_ln "$DOTFILES_DIR/.vim/bundle/vim-gradle/" ~/.vim/bundle
tmp_dir_ln "$DOTFILES_DIR/.vim/pack/" ~/.vim

# Install configuration files for Compton.
echo "Installing Picom configuration files..."
mkdir -p ~/.config/picom
tmp_ln "$DOTFILES_DIR/.config/picom/picom.conf" ~/.config/picom
tmp_ln "$DOTFILES_DIR/.lambdadotfiles/launch_picom.sh" ~/.config/plasma-workspace/env

# Install KDE stuff.
## Install konsole stuff.
echo "Installing konsole configuration files..."
cp "$DOTFILES_DIR/.config/konsolerc" ~/.config
mkdir -p ~/.local/share/konsole
tmp_ln "$DOTFILES_DIR/.local/share/konsole/LambdaSolarized.colorscheme" ~/.local/share/konsole
tmp_ln "$DOTFILES_DIR/.local/share/konsole/lambdaurora.profile" ~/.local/share/konsole

# Install configuration files for i3.
echo "Installing i3 configuration files..."
mkdir -p ~/.config/i3
tmp_ln "$DOTFILES_DIR/.config/i3/config" ~/.config/i3

# Install configuration files for polybar.
mkdir -p ~/.config/polybar
tmp_ln "$DOTFILES_DIR/.config/polybar/config" ~/.config/polybar
tmp_ln "$DOTFILES_DIR/.config/polybar/launch.sh" ~/.config/polybar

# Install configuration files for dunst.
echo "Installing dunst configuration files..."
tmp_dir_ln "$DOTFILES_DIR/.config/dunst" ~/.config

# Install configuration files for rofi.
echo "Installing rofi configuration files..."
mkdir -p ~/.config/rofi
tmp_ln "$DOTFILES_DIR/.config/rofi/config.rasi" ~/.config/rofi
tmp_ln "$DOTFILES_DIR/.config/rofi/lambdaurora.rasi" ~/.config/rofi

# Install configuration files for kitty.
echo "Installing kitty configuration files..."
mkdir -p ~/.config/kitty
tmp_ln "$DOTFILES_DIR/.config/kitty/kitty.conf" ~/.config/kitty

# Install Xresources files.
echo "Installing some other configuration files..."
tmp_ln "$DOTFILES_DIR/.Xdefaults" ~
tmp_ln "$DOTFILES_DIR/.xdefaults/" ~

unalias tmp_ln
unalias tmp_dir_ln
