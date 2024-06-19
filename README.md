# nixos-tests-flake-parts

Example repo using [nixos-tests](https://github.com/esselius/nixos-tests) and [ez-configs](https://github.com/ehllie/ez-configs).

Define actual nixos configs in `nixos-configurations` and nixos tests using the same modules in `tests`.

Run test with `nix run github:esselius/nixos-tests-flake-parts#nixosTests.auth`, for interactive just add `-- --interactive` 