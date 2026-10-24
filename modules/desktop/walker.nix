{
  flake.modules.homeManager.walker = {
    services.elephant.enable = true;
    services.walker = {
      enable = true;
      systemd.enable = true;
    };
  };
}
