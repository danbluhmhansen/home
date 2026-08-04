{
  flake.modules.homeManager.firefox = {pkgs, ...}: {
    programs.firefox = {
      enable = true;

      languagePacks = ["en-US" "da-DK"];

      policies = {
        Cookies.Behavior = "reject-tracker";
        Cookies.BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";

        DisableAppUpdate = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;

        DisplayBookmarksToolbar = "newtab";

        DNSOverHTTPS.Enabled = true;
        DNSOverHTTPS.Fallback = true;

        EnableTrackingProtection.Value = true;
        EnableTrackingProtection.Cryptomining = true;
        EnableTrackingProtection.Fingerprinting = true;
        EnableTrackingProtection.EmailTracking = true;

        EnterprisePoliciesEnabled = true;

        FirefoxHome.Search = true;
        FirefoxHome.TopSites = true;
        FirefoxHome.SponsoredTopSites = false;
        FirefoxHome.Highlights = true;
        FirefoxHome.Pocket = false;
        FirefoxHome.SponsoredPocket = false;
        FirefoxHome.Snippets = true;

        FirefoxSuggest.WebSuggestions = true;
        FirefoxSuggest.SponsoredSuggestions = false;
        FirefoxSuggest.ImproveSuggest = false;

        Homepage.StartPage = "previous-session";

        HttpsOnlyMode = "enabled";
        NetworkPrediction = true;
        NewTabPage = true;
        OfferToSaveLoginsDefault = false;
        OverrideFirstRunPage = "";

        RequestedLocales = ["en-us" "da-dk"];

        SearchEngines.Default = "DuckDuckGo";
        SearchEngines.Remove = ["Bing" "Google" "Perplexity"];

        SearchSuggestEnabled = true;

        SkipTermsOfUse = true;
      };

      profiles.dan = {
        bookmarks.force = true;
        bookmarks.settings = [
          {
            toolbar = true;
            bookmarks = [
              {
                name = "dev";
                bookmarks = [
                  {
                    name = "Forgejo";
                    url = "https://forgejo.920301.xyz";
                  }
                  {
                    name = "GitHub";
                    url = "https://github.com";
                  }
                ];
              }
              {
                name = "ttrpg";
                bookmarks = [
                  {
                    name = "Foundry";
                    url = "https://foundry.920301.xyz";
                  }
                ];
              }
              {
                name = "Streaming";
                bookmarks = [
                  {
                    name = "Jellyfin";
                    url = "https://jf.920301.xyz";
                  }
                  {
                    name = "Ombi";
                    url = "https://ombi.920301.xyz";
                  }
                  {
                    name = "Movies";
                    url = "https://radarr.920301.xyz";
                  }
                  {
                    name = "Shows";
                    url = "https://sonarr.920301.xyz";
                  }
                ];
              }
            ];
          }
        ];

        containersForce = true;
        containers.personal = {
          name = "Personal";
          icon = "fingerprint";
          color = "purple";
        };

        search = {
          default = "ddg";
          force = true;
          engines = {
            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            perplexity.metaData.hidden = true;
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = pkgs.lib.attrsToList {
                    channel = "unstable";
                    type = "packages";
                    query = "{searchTerms}";
                  };
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = pkgs.lib.attrsToList {
                    channel = "unstable";
                    type = "packages";
                    query = "{searchTerms}";
                  };
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "Home Manager" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = pkgs.lib.attrsToList {
                    channel = "unstable";
                    source = "home_manager";
                    type = "packages";
                    query = "{searchTerms}";
                  };
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
            };
            Noogle = {
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = pkgs.lib.attrsToList {term = "{searchTerms}";};
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@na"];
            };
            GitHub = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = pkgs.lib.attrsToList {q = "{searchTerms}";};
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://simpleicons.org/icons/github.svg";
                hash = "sha256-O/jM7q2CCuxQ1O6CWj/QLFoc1mZcyc9Mvz2ciGGiBLs=";
              };
              definedAliases = ["@gh"];
            };
            "crates.io" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = pkgs.lib.attrsToList {q = "{searchTerms}";};
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://simpleicons.org/icons/rust.svg";
                hash = "sha256-laKR2Ih2ENEDcErcxcXyy/pMgKlvjnKwBTHVaRvrZ6g=";
              };
              definedAliases = ["@rs"];
            };
          };
        };

        settings = {
          "browser.display.document_color_use" = 0;
          "browser.fullscreen.autohide" = false;
          "browser.fullscreen.exit_on_escape" = false;
          "browser.ml.chat.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.startup.page" = 3;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.warnOnQuitShortcut" = false;

          "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;

          "identity.fxaccounts.enabled" = false;
          "signon.rememberSignons" = false;
          "intl.locale.requested" = "en-US,da-DK";
          "dom.security.https_only_mode" = true;

          "sidebar.main.tools" = "history,bookmarks";
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = false;
          "sidebar.visibility" = "hide-sidebar";

          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [];
              unified-extensions-area = [
                "7esoorv3_alefvanoon_anonaddy_me-browser-action"
                "gdpr_cavi_au_dk-browser-action"
              ];
              nav-bar = [
                "sidebar-button"
                "back-button"
                "forward-button"
                "stop-reload-button"
                "customizableui-special-spring1"
                "vertical-spacer"
                "urlbar-container"
                "customizableui-special-spring2"
                "downloads-button"
                "unified-extensions-button"
                "ublock0_raymondhill_net-browser-action"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
                "alltabs-button"
              ];
              vertical-tabs = [];
              PersonalToolbar = ["personal-bookmarks"];
            };
            seen = [
              "save-to-pocket-button"
              "developer-button"
              "_testpilot-containers-browser-action"
              "7esoorv3_alefvanoon_anonaddy_me-browser-action"
              "gdpr_cavi_au_dk-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "screenshot-button"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            ];
            dirtyAreaCache = ["nav-bar" "vertical-tabs" "PersonalToolbar" "unified-extensions-area" "TabsToolbar"];
            currentVersion = 22;
            newElementCount = 0;
          };

          "browser.uiCustomization.navBarWhenVerticalTabs" = [
            "firefox-view-button"
            "sidebar-button"
            "back-button"
            "forward-button"
            "stop-reload-button"
            "customizableui-special-spring1"
            "vertical-spacer"
            "urlbar-container"
            "customizableui-special-spring2"
            "downloads-button"
            "unified-extensions-button"
            "ublock0_raymondhill_net-browser-action"
            "alltabs-button"
          ];
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          consent-o-matic
          libredirect
          bitwarden
        ];
      };
    };
  };
}
