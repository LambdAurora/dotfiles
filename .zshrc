############################################################
############################################################
###                                                      ###
###                LambdAurora's .zshrc                  ###
###                                                      ###
############################################################
############################################################

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Theme
ZSH_THEME="lambdaurora"

# Options
#ENABLE_CORRECTION="true"
## Version control
DISABLE_UNTRACKED_FILES_DIRTY="true"


# Plugins
plugins=(encode64 git)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

## Language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'
export GIT_EDITOR='vim'

## Compilation flags
export ARCHFLAGS="-arch x86_64"
### Clang <3
export CC="clang"
export CXX="clang++"

## Wine
export WINEARCH='win64'

## Common
export USER_HOME=$HOME

# Check if gnome-terminal exists, if it exists it will define $TERMINAL variable.
if (( $+commands[gnome-terminal] ))
then
	export TERMINAL='gnome-terminal'
fi

## ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

## Java
# Enable anti-aliased rendering for Swing applications.
export JAVA_TOOL_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

## Aliases
. ~/.lambdadotfiles/aliases

[[ "$DISPLAY" && -z "$de" ]] && type -p xprop &>/dev/null && de="$(xprop -root | awk '/KDE_SESSION_VERSION/')"

case $de in
    "KDE_SESSION_VERSION"*) . ~/.lambdadotfiles/plasmautils ;;
esac

# Other
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

