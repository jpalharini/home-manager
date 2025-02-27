{
  description = "Joao's Nubank MacBook configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-joao.url = "github:jpalharini/nixpkgs/bump-espanso";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    secrets-repo = {
      url = "git+ssh://git@nu-precision.home/srv/git/secrets";
      flake = false;
    };
  };

  outputs = { 
    self, nixpkgs, nixpkgs-joao, nix-darwin, home-manager, secrets-repo, ... 
  } @ inputs: 
  
    let
      inherit (self) outputs;

      secrets = builtins.fromTOML (builtins.readFile "${secrets-repo}/secrets.toml");

      mkNixosConfiguration = args: nixpkgs.lib.nixosSystem {
        system = args.system;
        modules = args.modules;
      };

      pkgsForSystem = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHomeConfiguration = args: home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSystem args.system;
        extraSpecialArgs = {
          inherit inputs secrets;
          pkgs-joao = import nixpkgs-joao {
            system = args.system;
            config.allowUnfree = true;
          };
        };
        modules = args.modules;
      };

    in {
      # todo: enable use of this in nu-precision
      nixosConfigurations = {
        nu-precision = mkNixosConfiguration {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
          ];
        };
      };

      darwinConfigurations."Joaos-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/configuration.nix
        ];
      };

      homeConfigurations = {
        "joao.palharini@joao.palharini" = mkHomeConfiguration {
          system = "aarch64-darwin";
          modules = [
            ./home-manager/macbook.nix
          ];
        };

        "jpalharini@nu-precision" = mkHomeConfiguration {
          system = "x86_64-linux";
          modules = [
            ./home-manager/linux.nix
          ];
        };
      };
    };
}
