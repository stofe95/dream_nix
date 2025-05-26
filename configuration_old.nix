# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ username, secrets, config, lib, pkgs, ... }:

{

  wsl = {
    enable = true;
    defaultUser = username;
    useWindowsDriver = true;
    startMenuLaunchers = true;
    usbip.enable = true;
  };
  
  time.timeZone = "America/Toronto";

  nixpkgs.config.allowUnfree = true;

  programs.zsh = {
    enable = true;
  };
  programs.nix-ld = {
    enable = true;
    libraries = config.hardware.graphics.extraPackages;
  };
  
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  environment.pathsToLink = ["/share/zsh"];

  environment.shells = [pkgs.zsh];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes"];
    };
    
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    }; 
    
  };
}
