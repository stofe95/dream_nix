### Trying to make a half-decent NixOS config

## Running on different platforms

Because WSL will not need the same setup as a full desktop environment, we have to break the config/home-manager up into chunks. The config that is shared between both environments is in hosts/common.nix, and then the configs that are run on each system are in hosts/desktop.nix or hosts/wsl.nix. The same principal in applied to the home-manager, which lives in home/common.nix, home/desktop.nix, and home/wsl.nix.

To rebuild on your system, you must specify which build you want using
```
sudo nixos-rebuild seitch --flake ~/path/to/flake#wsl
```
for wsl, or for desktop:
```
sudo nixos-rebuild seitch --flake ~/path/to/flake#desktop
```
Haven't yet worked out a way to edit the hyprland config on desktop, that's the next step.
