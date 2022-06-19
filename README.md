# Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

File `playbook-system.yml` contains all the packages and vars e.g: user/home

Basic system setup done by running `sh install-system`

This will install Dropbox and ansible-vault will need the key to decrypt secrets

`ansible-vault decrypt --vault-password-file ~/Dropbox/warden aws/.aws/config aws/.aws/credentials ssh/.ssh/id_ed25519 ssh/.ssh/id_ed25519.pub npmrc/.npmrc`

After decrypt forget about secrets changes with:
`git update-index --skip-worktree aws/.aws/config aws/.aws/credentials ssh/.ssh/id_ed25519 ssh/.ssh/id_ed25519.pub npmrc/.npmrc`
