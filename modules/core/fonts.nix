{
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [maple-mono.NF noto-fonts noto-fonts-color-emoji];
  };
}
