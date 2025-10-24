{pkgs, ...}: {
  imports = [
    ./services/authelia.nix
    ./services/actual.nix
    ./services/traefik.nix
    ./services/glance.nix
    ./services/lldap.nix
    ./services/forgejo.nix
    ./services/foundryvtt.nix
    ./services/gameyfin.nix
    ./services/metube.nix
    ./services/minio.nix
    ./services/postgres.nix
    ./services/resume.nix
    ./services/radicale.nix
    ./services/stalwart.nix
    ./services/streaming.nix
    ./services/cv.nix
    ./services/vaultwarden.nix
    ./services/wishlist.nix
  ];

  home.packages = with pkgs; [podman-tui systemctl-tui];

  programs.git.extraConfig.credential.helper = let
    pkg = pkgs.git.override {withLibsecret = true;};
  in "${pkg}/bin/git-credential-libsecret";

  services.podman.enable = true;
}
