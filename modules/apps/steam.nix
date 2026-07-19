{
  flake.modules.nixos.steam = {pkgs, ...}: {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      extraPackages = [pkgs.hidapi];
      gamescopeSession = {
        enable = true;
        steamArgs = ["-tenfoot" "-pipewire-dmabuf"];
      };
    };
    services.seatd.enable = true;
  };
  flake.modules.darwin.steam.homebrew.casks = [
    {
      name = "steam";
      args.appdir = "~/Applications";
    }
  ];
}
