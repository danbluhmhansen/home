{
  flake.modules.nixos.cloudflare-warp = {services.cloudflare-warp.enable = true;};

  flake.modules.darwin.cloudflare-warp.homebrew.casks = [
    {
      name = "cloudflare-warp";
      args.appdir = "~/Applications";
    }
  ];
}
