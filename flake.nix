{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    ez-configs.url = "github:ehllie/ez-configs";
    authentik-nix.url = "github:nix-community/authentik-nix";
    nixos-tests.url = "github:esselius/nixos-tests";
  };

  outputs = inputs@{ self, flake-parts, ... }: flake-parts.lib.mkFlake
  { inherit inputs; }
  {
      imports = [
        inputs.ez-configs.flakeModule
        inputs.nixos-tests.flakeModule
      ];

      systems = [ "aarch64-linux" "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];

      ezConfigs = {
        root = ./.;
        globalArgs = { inherit inputs; };
      };

      perSystem = { pkgs, ... }: {
        nixosTests = {
          path = ./tests;
          args = {
            inherit inputs;
            myModules = self.nixosModules;
          };
        };
      };
    };
}
