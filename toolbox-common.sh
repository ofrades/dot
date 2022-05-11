#!/bin/bash

set -e

function have {
  command -v "$1" &> /dev/null
}

# install ansible
have ansible || sudo dnf install ansible

# install ansible community plugins
[ -d ~/.ansible/collections/ansible_collections/community ] || \
  ansible-galaxy collection install community.general

# Install LinuxBrew
if ! have "brew"; then
  sudo dnf group install -y 'Development Tools'
  sudo dnf install -y procps-ng curl file git libxcrypt-compat
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# if ! have "terraform"; then
#   sudo dnf install -y dnf-plugins-core
#   sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
#   sudo dnf -y install terraform
# fi

if ! have "gh"; then
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh
fi

ansible-playbook toolbox-common.yml --ask-become-pass