{ lib, flake-parts-lib, ... }:
let
  inherit (lib) concatMapAttrs mkOption types;
  inherit (builtins) readDir;
  inherit (lib.strings) removeSuffix;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, ... }:
      let
        testDriver = dir: file: "${(pkgs.testers.runNixOSTest (import (dir + file))).driver}/bin/nixos-test-driver";
        mkApps = dir: concatMapAttrs (a: b: { "test-${removeSuffix ".nix" a}".program = testDriver dir ("/" + a); }) (readDir dir);
      in
      {
        options.tests.path = mkOption {
          type = types.pathInStore;
        };
        config.apps = mkApps config.tests.path;
      });
  };
}
