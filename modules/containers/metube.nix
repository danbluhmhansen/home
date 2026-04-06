{
  flake.modules.homeManager.metube = {config, ...}: {
    services.podman.containers.metube = {
      image = "ghcr.io/alexta69/metube";
      environment = {
        PUBLIC_HOST_URL = "https://metube.920301.xyz";
        YTDL_OPTIONS = "'${toString (builtins.toJSON {
          writesubtitles = true;
          subtitleslangs = ["en" "-live_chat"];
          updatetime = false;
          postprocessors = [
            {
              key = "Exec";
              exec_cmd = "chmod 0664";
              when = "after_move";
            }
            {
              key = "FFmpegEmbedSubtitle";
              already_have_subtitle = false;
            }
            {
              key = "FFmpegMetadata";
              add_chapters = true;
            }
          ];
        })}'";
      };
      network = ["traefik"];
      volumes = ["${config.home.homeDirectory}/srv/downloads:/downloads"];
      labels = {
        "traefik.http.routers.metube.rule" = ''Host(`metube.920301.xyz`)'';
        "traefik.http.routers.metube.middlewares" = "authelia@docker";
        "traefik.http.services.metube.loadbalancer.server.port" = "8081";
        "glance.name" = "MeTube";
        "glance.icon" = "sh:metube";
        "glance.url" = "https://metube.920301.xyz";
        "glance.description" = "'YouTube downloader'";
      };
    };
  };
}
