# Info

`system.yml` is what contains flatpaks and base system configurations

`toolbox.yml` is what contains the development tools for work.

## Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

File `common.yml` contains all the packages and vars e.g: user/home

Basic system setup done by running `sh install`

This will install Dropbox and ansible-vault will need the key to decrypt secrets

`ansible-vault decrypt aws/.aws/config aws/.aws/credentials ssh/.ssh/id_ed25519 ssh/.ssh/id_ed25519.pub npmrc/.npmrc`

Create a container `toolbox create [name]`

Enter the container by running `toolbox enter [name]`

Install dev tools by running `sh toolbox`.
