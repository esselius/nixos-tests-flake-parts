{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    ez-configs.url = "github:ehllie/ez-configs";
    authentik-nix.url = "github:nix-community/authentik-nix";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }: {
      imports = [
        inputs.ez-configs.flakeModule

        ./flake-module.nix
      ];
      systems = [ "aarch64-darwin" ];

      ezConfigs = {
        root = ./.;
        globalArgs = { inherit inputs; };
      };

      perSystem = { pkgs, ... }: {
        nixosTests = {
          path = ./tests;
          args = {
            inherit inputs;
            myModules = config.flake.nixosModules;
          };
        };
      };
    });
}
