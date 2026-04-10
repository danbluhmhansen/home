{inputs, ...}: let
  common = {
    sops.validateSopsFiles = false;
    sops.age.generateKey = true;
  };
in {
  flake.modules.nixos.core = common // {imports = [inputs.sops.nixosModules.sops];};
  flake.modules.nixos.dan = {config, ...}: {
    sops.defaultSopsFile = "${config.users.users.dan.home}/.config/sops/secrets/main.yml";
    sops.age.keyFile = "${config.users.users.dan.home}/.config/sops/age/keys.txt";
  };
  flake.modules.darwin.core = common // {imports = [inputs.sops.darwinModules.sops];};
  flake.modules.darwin.dan = {config, ...}: {
    sops.defaultSopsFile = "${config.users.users.dan.home}/Library/Application Support/sops/secrets/main.yml";
    sops.age.keyFile = "${config.users.users.dan.home}/Library/Application Support/sops/age/keys.txt";
  };
  flake.modules.homeManager.core = {
    config,
    pkgs,
    lib,
    ...
  }:
    lib.recursiveUpdate common {
      imports = [inputs.sops.homeManagerModules.sops];
      sops.defaultSopsFile =
        if pkgs.stdenv.isDarwin
        then "${config.home.homeDirectory}/Library/Application Support/sops/secrets/main.yml"
        else "${config.home.homeDirectory}/.config/sops/secrets/main.yml";
      sops.age.keyFile =
        if pkgs.stdenv.isDarwin
        then "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt"
        else "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      sops.secrets.cachix = {};
      sops.templates."cachix.dhall".content = ''
        { authToken = "${config.sops.placeholder.cachix}"
        , hostname = "https://cachix.org"
        , binaryCaches = [] : List { name : Text, secretKey : Text }
        }
      '';
      home.file = {
        ".config/cachix/cachix.dhall".source =
          config.lib.file.mkOutOfStoreSymlink config.sops.templates."cachix.dhall".path;
      };
    };
}
