{
  pkgs,
  config,
  lib,
  ...
}: let
  packageSettings = lib.optionalAttrs pkgs.stdenv.isDarwin {
    package = pkgs.firefox-bin;
  };

  cfg = config.programs.firefox;
in {
  home.file."Library/Application Support/Firefox/profiles.ini" = let
    profiles =
      lib.flip lib.mapAttrs' cfg.profiles (_: profile:
        lib.nameValuePair "Profile${toString profile.id}" {
          Name = profile.name;
          Path =
            if pkgs.stdenv.isDarwin
            then "Profiles/${profile.path}"
            else profile.path;
          IsRelative = 1;
          Default =
            if profile.isDefault
            then 1
            else 0;
        })
      // {
        General = {
          StartWithLastProfile = 1;
        };
      };

    profilesIni = lib.generators.toINI {} profiles;
  in {
    enable = true;
    text = lib.mkForce profilesIni;
  };

  programs.firefox =
    {
      profiles = {
        ${config.home.username} = {
          search = {
            default = "DuckDuckGo";
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
          extensions = with config.nur.repos.rycee.firefox-addons; [
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
    // packageSettings;
}
