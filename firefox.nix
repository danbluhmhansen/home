{
  pkgs,
  config,
  ...
}: {
  programs.firefox = {
    package = pkgs.firefox-bin;
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
        ];
      };
    };
  };
}
