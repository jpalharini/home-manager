{
  description = "Joao's Home Manager Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-joao.url = "github:jpalharini/nixpkgs/bump-espanso";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-joao, home-manager, ... }: {
    homeConfigurations = {
      "joao.palharini@joao.palharini" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        pkgs-joao = nixpkgs-joao.legacyPackages.aarch64-darwin;

        extraSpecialArgs = { 
          inherit inputs outputs;
        };

        modules = [
          ./macbook.nix
        ];
      };
    };
  };
    
