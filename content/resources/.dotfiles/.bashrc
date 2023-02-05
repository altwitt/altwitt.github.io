#!/bin/bash

# Specify default editor. Possible values: vim, nano, ed etc.
export EDITOR=vim

# File search functions
function f() { find . -iname "*$1*" ${@:2} }

function r() { grep "$1" ${@:2} -R . }



# KILL ALL
function ka(){

    cnt=$( p $1 | wc -l)  # total count of processes found
    klevel=${2:-15}       # kill level, defaults to 15 if argument 2 is empty

    echo -e "\nSearching for '$1' -- Found" $cnt "Running Processes .. "
    p $1

    echo -e '\nTerminating' $cnt 'processes .. '

    ps aux  |  grep -i $1 |  grep -v grep   | awk '{print $2}' | xargs sudo kill -klevel
    echo -e "Done!\n"

    echo "Running search again:"
    p "$1"
    echo -e "\n"
}

function k() { kill $(ps aux | grep $1 | grep -v grep | awk '{print $2}')}

# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Example aliases
alias cppcompile='c++ -std=c++11 -stdlib=libc++'
alias g='git'
alias la='ls -la'


export PATH="/usr/local/bin:$PATH"
chflags nohidden ~/Library
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
sudo spctl --master-disable

# Update and clean homebrow in one command
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

# get the Homebrew-managed zsh site-functions on your FPATH before initialising zsh’s completion facility.
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad



