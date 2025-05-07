# Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

`nix/` contains all the packages and configs

```bash
# after system change
sudo nixos-rebuild switch --flake .#some-machine(gtx970 or normal)
# after config changes
home-manager switch --flake .#some-user(ofrades)
```
