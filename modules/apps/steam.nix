{
  flake.modules.nixos.steam = {
    programs.gamescope.enable = true;
    programs.gamescope.capSysNice = true;
    programs.gamescope.args = ["--adaptive-sync" "--hdr-enabled" "--rt"];
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.steam.gamescopeSession.steamArgs = ["-tenfoot" "-pipewire-dmabuf"];
  };
  flake.modules.darwin.steam.homebrew.casks = [
    {
      name = "steam";
      args.appdir = "~/Applications";
    }
  ];
}
