# Setup development tools

Clone this repo and chdir `git clone git@github.com:ofrades/dot.git && cd dot`

`nix/` contains all the packages and configs

```bash
home-manager switch -f ~/dot/nix/home-manager/home.nix
sudo cp ~/.local/share/xsessions/i3-nix.desktop /usr/share/xsessions/i3-nix.desktop
sudo chmod 644 /usr/share/xsessions/i3-nix.desktop
sudo systemctl restart gdm
```
