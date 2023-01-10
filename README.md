# Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

File `playbook-system.yml` contains all the packages and vars e.g: user/home

First run needs:

- Dropbox (vault password file)
- `sudo apt install ansible`
- `ansible-galaxy collection install community.general`
- `ansible-vault decrypt --vault-password-file ~/Dropbox/warden ssh/.ssh/id_ed25519 ssh/.ssh/id_ed25519.pub`

After decrypt forget about file changes like:

`git update-index --skip-worktree aws/.aws/config aws/.aws/credentials ssh/.ssh/id_ed25519 ssh/.ssh/id_ed25519.pub`

Subsquent runs:

- `ansible-playbook playbook.yml --ask-become-pass`

