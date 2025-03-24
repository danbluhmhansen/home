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

      profiles.${config.me.username} = {
        search = {
          default = "ddg";
          force = true;
          engines = {
            bing.metaData.hidden = true;
            google.metaData.hidden = true;
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
          stylus
        ];
      };

      policies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        EnableTrackingProtection.Value = true;
        EnableTrackingProtection.Cryptomining = true;
        EnableTrackingProtection.Fingerprinting = true;
        EnableTrackingProtection.EmailTracking = true;
        FirefoxHome.SponsoredTopSites = false;
        FirefoxHome.Pocket = false;
        FirefoxHome.SponseredPocket = false;
        FirefoxSuggest.SponsoredSuggestions = false;
        FirefoxSuggest.ImproveSuggest = false;
        HardwareAcceleration = true;
        NoDefaultBookmarks = true;
      };
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      package = pkgs.firefox-bin;
      policies = {
        EnterprisePoliciesEnabled = true;
      };
    };
}
