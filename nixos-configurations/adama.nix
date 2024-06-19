{ inputs, config, ezModules, ... }:

{
  imports = [
    inputs.authentik-nix.nixosModules.default

    ezModules.auth
  ];

  auth.enable = true;
  auth.env-file = builtins.toFile "authentik-env-file" ''
    AUTHENTIK_SECRET_KEY=qwerty123456
  '';
}
