{
  config,
  timeZone,
  ...
}: {
  services.podman.containers.radicale = {
    image = "docker.io/tomsquest/docker-radicale:latest";
    environment = {TZ = timeZone;};
    network = ["traefik"];
    volumes = [
      "${config.home.homeDirectory}/srv/radicale/config:/config"
      "${config.home.homeDirectory}/srv/radicale/data:/data"
    ];
    labels = {
      "traefik.http.routers.radicale.rule" = ''Host(`radicale.920301.xyz`)'';
      "traefik.http.routers.radicale.middlewares" = "authelia@docker,x-remote-user@docker";
      "traefik.http.services.radicale.loadbalancer.server.port" = "5232";
      "traefik.http.middlewares.x-remote-user.plugin.htransformation.Rules[0].Name" = "X-Remote-User";
      "traefik.http.middlewares.x-remote-user.plugin.htransformation.Rules[0].Header" = "Remote-User";
      "traefik.http.middlewares.x-remote-user.plugin.htransformation.Rules[0].Type" = "Rename";
      "traefik.http.middlewares.x-remote-user.plugin.htransformation.Rules[0].Value" = "X-Remote-User";
      "glance.name" = "Radicale";
      "glance.icon" = "sh:radicale";
      "glance.url" = "https://radicale.920301.xyz";
      "glance.description" = "'A simple CalDAV and CardDAV server'";
    };
    addCapabilities = ["SETUID" "SETGID" "CHOWN" "KILL"];
    dropCapabilities = ["ALL"];
    extraPodmanArgs = ["--init" "--read-only" "--security-opt no-new-privileges:true"];
  };
}
