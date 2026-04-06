{
  flake.modules.homeManager.cv = {
    config,
    pkgs,
    ...
  }: {
    services.podman.containers.cv = {
      image = "docker.io/11notes/caddy:2.10.0";
      environment = {TZ = "Europe/Copenhagen";};
      network = ["traefik"];
      volumes = [
        "${pkgs.writeScript "default.json" ''
          {
            "apps": {
              "http": {
                "servers": {
                  "srv0": {
                    "listen": [":80"],
                    "routes": [{ "handle": [{ "handler": "file_server", "root": "/caddy/var/site" }] }]
                  }
                }
              }
            }
          }
        ''}:/caddy/etc/default.json"
        "${config.home.homeDirectory}/srv/cv/site:/caddy/var/site"
      ];
      labels = {
        "traefik.http.routers.cv.rule" = ''Host(`cv.920301.xyz`)'';
        "traefik.http.services.cv.loadbalancer.server.port" = "80";
      };
      extraPodmanArgs = ["--read-only" "--sysctl net.ipv4.ip_unprivileged_port_start=80"];
    };
  };
}
