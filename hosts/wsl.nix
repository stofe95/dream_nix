# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ inputs, username, secrets, config, lib, ... }:

{
 #virtualisation.wsl.enable = true;
  #virtualisation.wsl.defaultUser = username;
 # virtualisation.wsl.useWindowsDriver = true;
 # virtualisation.wsl.startMenuLaunchers = true;
 # virtualisation.wsl.usbip.enable = true; 
 imports = [
   inputs.nixos-wsl.nixosModules.wsl
  ];
 wsl.enable = true;

 boot.loader.grub.enable = false;
 boot.loader.systemd-boot.enable = false;

 fileSystems."/" = {
   device = "none";
   fsType = "tmpfs";
  };
}
