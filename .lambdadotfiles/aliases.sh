#!/bin/zsh
############################################################
############################################################
###                                                      ###
###               LambdAurora's Aliases                  ###
###                                                      ###
############################################################
############################################################

function git() {
	if [ "$1" = tag -a "$2" = rename ]; then
		shift
		shift
		local old_name="$1"
		local new_name="$2"
		shift
		shift
		set -- "$new_name" "$old_name" "$@"
		git tag "$@" && git tag -d "$old_name"
		return;
	fi

	command git "$@"
}

alias cls="clear"
alias home="cd ~"
alias cd..="cd .."
alias please="sudo"
alias gadd="git add ."
alias gstat="git status"
alias gcommit="git commit -S -m "
alias gpsign="git commit --amend --no-edit -S"
alias gpush="git push origin"
alias gpushfork="git push fork"
alias gpull="git pull origin"
alias gpullfork="git pull origin fork"
alias gdiff="git diff"
alias rofi="~/.lambdadotfiles/plasma_rofi"
alias wine32="WINEPREFIX=\"$HOME/.wine32\" WINEARCH=win32 wine"
