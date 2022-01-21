# Info

`system.yml` is what constains flatpaks and base system configurations

`toolbox.yml` is what contains the development tools for work.

## Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

Basic system setup done by running `sh install`

Create a container `toolbox create [name]`

Enter the container by running `toolbox enter [name]`

Install dev tools by running `ansible-playbook toolbox.yml --ask-become-pass`.
