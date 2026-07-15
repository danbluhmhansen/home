{inputs, ...}: {
  flake.modules.darwin.mpv = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.mpv];
    homebrew.casks = [
      {
        name = "mpv";
        args.appdir = "~/Applications";
      }
    ];
  };

  flake.modules.homeManager.mpv = {pkgs, ...}: {
    programs.mpv.enable = pkgs.stdenv.isLinux;
    programs.yt-dlp.enable = true;
  };
}
