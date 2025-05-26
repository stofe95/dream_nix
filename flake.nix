
{
  description = "NixOS with WSL and Home Manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }: {
        nixosConfigurations = {
          desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
	    specialArgs = {
	      username = "chris";
	      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
	      };
            modules = [
              ./hosts/common.nix
              ./hosts/desktop.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.chris = import ./home/desktop.nix;
              }
            ];
          };

          wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
	      username = "chris";
	      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
	      };

            modules = [
              ./hosts/common.nix
              ./hosts/wsl.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.chris = import ./home/wsl.nix;
              }
            ];
          };
        };
	};
}
