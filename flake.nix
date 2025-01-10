{
  description = "Joao's Nubank MacBook configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-joao.url = "github:jpalharini/nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-joao, nix-darwin, home-manager, ... }: {
    darwinConfigurations."Joaos-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."joao.palharini" = import ./home-manager/macbook.nix;
        }
      ];
    };
  };
}
