# Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

`nix/` contains all the packages and configs

```bash
# after system change
sudo nixos-rebuild switch --flake .#ofrades
# after config changes
home-manager switch -f ~/dot/nix/home-manager/home.nix
```
