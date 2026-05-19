{
  flake.modules.nixos.steam = {pkgs, ...}: {
    hardware.steam-hardware.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = ["--adaptive-sync" "--hdr-enabled" "--rt"];
    };
    programs.steam = {
      enable = true;
      extraPackages = [pkgs.hidapi];
      gamescopeSession.enable = true;
      gamescopeSession.steamArgs = ["-tenfoot" "-pipewire-dmabuf"];
    };
  };
  flake.modules.darwin.steam.homebrew.casks = [
    {
      name = "steam";
      args.appdir = "~/Applications";
    }
  ];
}
