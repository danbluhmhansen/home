{
  config,
  timeZone,
  ...
}: {
  sops.secrets.lldap = {};

  services.podman.containers.lldap = {
    image = "docker.io/lldap/lldap:stable";
    environment = {
      UID = "1000";
      GID = "1000";
      TZ = timeZone;
    };
    environmentFile = [config.sops.secrets.lldap.path];
    network = ["traefik"];
    volumes = ["${config.home.homeDirectory}/srv/lldap:/data"];
    labels = {
      "traefik.http.routers.lldap.rule" = ''Host(`ldap.920301.xyz`)'';
      "traefik.http.services.lldap.loadbalancer.server.port" = "17170";
      "glance.name" = "LLDAP";
      "glance.icon" = "sh:lldap";
      "glance.url" = "https://ldap.920301.xyz";
      "glance.description" = "'Light LDAP implementation'";
    };
  };
}
