{
  flake,
  pkgs,
  lib,
  ...
}: let
  inherit (flake) config inputs;
in {
  programs.firefox =
    {
      enable = true;
      profiles = {
        ${config.me.username} = {
          search = {
            default = "ddg";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
            };
          };
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            consent-o-matic
            libredirect
            ublock-origin
            vimium
            stylus
            bitwarden
          ];
        };
      };
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      package = pkgs.firefox-bin;
    };
}
