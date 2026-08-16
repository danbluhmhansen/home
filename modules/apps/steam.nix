{
  flake.modules.nixos.steam = {pkgs, ...}: {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      extraPackages = [pkgs.hidapi];
      extraCompatPackages = with pkgs; [proton-ge-bin];
      gamescopeSession = {
        enable = true;
        steamArgs = ["-tenfoot" "-pipewire-dmabuf"];
      };
      protontricks.enable = true;
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
