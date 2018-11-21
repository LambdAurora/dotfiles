############################################################
############################################################
###							 ###
###		    LambdAurora's .zshrc		 ###
###							 ###
############################################################
############################################################

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/lambdaurora/.oh-my-zsh

# Theme
ZSH_THEME="agnoster_lambda"

# Options
#ENABLE_CORRECTION="true"
## Version control
DISABLE_UNTRACKED_FILES_DIRTY="true"


# Plugins
plugins=(encode64 git git_remote_branch zsh-syntax-highlighting)


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
export WINEARCH='win32'

## Common
export USER_HOME=$HOME

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

## Aliases
. ./.lambdadotfiles/aliases

# Other
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
