{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ...}: 
    let
      lib = nixpkgs.lib;
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
      username = "chris";
    in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit username secrets; };
        modules = [
          ./configuration.nix
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username; }; 
            home-manager.backupFileExtension = "hm";
          }
        ];
      };
    };
  };
}
