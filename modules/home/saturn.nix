{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./services/forgejo.nix
    ./services/foundryvtt.nix
    ./services/streaming.nix
  ];

  sops.defaultSopsFile = "${config.home.homeDirectory}/.config/sops/secrets/main.yml";
  sops.validateSopsFiles = false;
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.age.generateKey = true;

  sops.secrets.foundryvtt = {};

  home.packages = with pkgs; [podman-tui systemctl-tui];

  programs.git.extraConfig.credential.helper = let
    pkg = pkgs.git.override {withLibsecret = true;};
  in "${pkg}/bin/git-credential-libsecret";

  services.podman.enable = true;

  services.podman.networks.traefik = {
    driver = "bridge";
    subnet = "10.80.0.0/24";
  };

  services.podman.containers.glance = {
    image = "docker.io/glanceapp/glance:latest";
    environment = {TZ = "Europe/Copenhagen";};
    network = ["traefik"];
    volumes = [
      "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
      "${config.home.homeDirectory}/srv/glance/glance.yml:/app/config/glance.yml:ro"
    ];
    labels = {
      "glance.name" = "Glance";
      "glance.icon" = "sh:glance";
      "glance.url" = "https://glance.920301.xyz";
      "glance.description" = ''"Dashboard"'';
    };
  };
}
