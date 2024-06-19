{ inputs, myModules }:

{
  name = "auth";
  nodes.authentik = { ... }: {
    virtualisation = {
      memorySize = 2048;
    };

    imports = [
      inputs.authentik-nix.nixosModules.default

      myModules.auth
    ];

    auth.enable = true;
    auth.env-file = builtins.toFile "authentik-env-file" ''
      AUTHENTIK_SECRET_KEY=qwerty123456
    '';
  };

  testScript = ''
    start_all()

    authentik.wait_for_unit("postgresql.service")
    authentik.wait_for_unit("redis-authentik.service")
    authentik.wait_for_unit("authentik-migrate.service")
    authentik.wait_for_unit("authentik-worker.service")
    authentik.wait_for_unit("authentik.service")
    authentik.wait_for_open_port(9000)
    authentik.wait_until_succeeds("curl -fL http://localhost:9000/if/flow/initial-setup/ >&2")
  '';
}
