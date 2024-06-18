{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [./flake-module.nix];
      systems = [ "aarch64-darwin" ];


      perSystem = { pkgs, ... }: {
        tests.path = ./tests;
      };
    };
}
