{ config, pkgs, ...}:

{
  imports = [
  ./common.nix
  ];

  home.packages = with pkgs; [
    firefox
    gimp
    inkscape
    zotero
    obsidian
  ];

  home.keyboard.options = [ "caps:escape" ];

  programs.fuzzel = {
      enable = true;
      settings = {
          main = {
              font = "JetBrainsMono Nerd Font 10";
              terminal = "alacritty";
              width = 50;
              lines = 10;
              horizontal-pad = 20;
              vertical-pad = 20;
          };

          colors = {
              background = "282a36ff";
              text = "f8f8f2ff";
              selection-text = "f8f8f2ff";
          };
      };
  };
}
