
{
  description = "NixOS with WSL and Home Manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl.url = "github:nix-community/NixOS-wsl";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }: {
        nixosConfigurations = {
          desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
	    specialArgs = {
	      username = "chris";
	      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
	      };
            modules = let
	      username = "chris";
	      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
	    in [
              ./hosts/common.nix
              ./hosts/desktop.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = ./home/desktop.nix; 
              }
            ];
          };

          wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
	      inherit (self) inputs;
	      username = "chris";
	      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
	      };

            modules = let
	      username = "chris";
	      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
	    in [
              ./hosts/common.nix
              ./hosts/wsl.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = ./home/wsl.nix;
              }
            ];
          };
        };
	};
}
