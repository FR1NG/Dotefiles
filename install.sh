#!/bin/bash

# thi is the list of dependencies i need
# greetd : the login manager
# use ly instead of greetd
# foot: terminal emulator as fallback
# lf: terminal based file manager
# nvim: ghaniy 3an ta3riif
# waybar: the system bar
# sway: window manager
# alacritty: terminal emulator
# blueman-manager: gui bluetooth manager
# fzf: fuzzy finder
# swaylock: lock manager
# qutebrowser: the best of the best minimal, configurable, vimlike browser
# wofi: application luncher
# mvp: media player
# spotify-player: terminal based spotify player
# axel: download manager
# slurp: waylan compositor selection utility
# stow
# lsd
# zsh
# prezto
# wl-clipboard
# swayidl
# wlogout

# TODO
# automate the installation of the font

function die() {
  printf $1
  exit
}

# list of packages to be installed
PACKAGES=("sway" "swaybar" "foot" "lf"\
  "nvim" "alacritty" "blueman-manager" "fzf" \
  "swaylock" "qutebrowser" "wofi" "mvp" "spotify-player" \
  "axel" "slurp" "stow" "lsd" "zsh" "wl-clipbord" \
  "swaydl" "wlogout" "git")

INSTALL_ALL=1

printf "would you like to install all packages or you want to chose [y/n]: "
read -r INSTALL_ALL

for package in ${PACKAGES[@]}; do
  if [ $INSTALL_ALL -eq 0 ]; then
    printf -r "would you like to install ($package) [y/n]: "
    read res
    while [ "$response" != "y" ] && [ "$response" != "n" ]; do
      printf "please chose y or n: "
      read -r res
    done
    if [ "$res" == "y"]; then
      print "installing $package..."  
      pacman -S $package --noconfirm
    fi
  else
    print "installing $package..."  
    pacman -S $package --noconfirm
  fi
  echo "$package"
done

echo "installing packages"
sudo pacman -Sy -y

echo "cloning dotefiles repository"
DOTE_PATH="${HOME}/dotefiles"
git clone https://github.com/FR1NG/Dotefiles.git $DOTE_PATH

if [ ! -d $DOTE_PATH ]; then
  die "dotefiles folder not found"
fi

for folder in $(ls $DOTE_PATH); do
	printf "do you want to link config of[y/n] ($folder): "
	read -r response
	echo "this is your $response"
	while [ "$response" != "y" ] && [ "$response" != "n" ]; do
		printf "please chose y or n: "
		read -r response
	done
  if [ $response == "y" ]; then
    printf "linking $response"
    stow $response
  fi
done

