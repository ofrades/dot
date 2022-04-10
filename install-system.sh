#!/bin/bash

set -e

function have {
  command -v "$1" &> /dev/null
}

# install fish
have fish || rpm-ostree install fish

# install stow
have stow || rpm-ostree install stow

# install chrome
have google-chrome || rpm-ostree install google-chrome-stable

# install alacritty
have alacritty || rpm-ostree install alacritty

# install fzf
have fzf || rpm-ostree install fzf

# install exa
have exa || rpm-ostree install exa

# install rnnoise
have exa || rpm-ostree install rnnoise

# install tweaks
have gnome-tweaks || rpm-ostree install gnome-tweaks

# install ansible
have ansible || rpm-ostree install ansible
have ansible || systemctl reboot

# install ansible community plugins
[ -d ~/.ansible/collections/ansible_collections/community ] || \
  ansible-galaxy collection install community.general

# decrypt secrets
ansible-vault decrypt --vault-password-file ~/Dropbox/warden aws/.aws/config aws/.aws/credentials ssh/.ssh/id_ed25519 ssh/.ssh/id_ed25519.pub npmrc/.npmrc

# flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.dropbox.Client

# Run Ansible
ansible-playbook install-system.yml --ask-become-pass

# echo 'setup dconf'
dconf load / < ~/dot/gnome.dconf

