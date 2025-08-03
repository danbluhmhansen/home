{pkgs, ...}: {
  imports = [
    ./services/traefik.nix
    ./services/glance.nix
    ./services/forgejo.nix
    ./services/foundryvtt.nix
    ./services/postgres.nix
    ./services/stalwart.nix
    ./services/streaming.nix
    ./services/cv.nix
  ];

  home.packages = with pkgs; [podman-tui systemctl-tui];

  programs.git.extraConfig.credential.helper = let
    pkg = pkgs.git.override {withLibsecret = true;};
  in "${pkg}/bin/git-credential-libsecret";

  services.podman.enable = true;
}
