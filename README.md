# Info

`system.yml` is what contains flatpaks and base system configurations

`toolbox.yml` is what contains the development tools for work.

## Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

File `common.yml` contains all the packages and vars e.g: user/home

Basic system setup done by running `sh install`

Create a container `toolbox create [name]`

Enter the container by running `toolbox enter [name]`

Install dev tools by running `sh toolbox`.
