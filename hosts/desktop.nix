# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ username, secrets, config, lib, pkgs, ... }:

{

  imports =
    [
      ./hosts/hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariable = true;
  boot.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  il8n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  services.xserver.xkb.options = "caps:escape";

  # Enable CUPS to print documents
  services.printing.enable = true;

  #Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    also.support32Bit = true;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "chris";

  environment.systemPackages = with pkgs; [
    hyprpaper
    waybar
    kitty
    rofi-wayland
  ];

  system.stateVersion = "24.11";
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
 
}
