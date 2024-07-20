{pkgs, ...}: {
  programs.helix = {
    defaultEditor = true;

    settings = {
      theme = "theme";

      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = [
            "diagnostics"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
        };
        lsp = {
          display-messages = true;
          auto-signature-help = false;
        };
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
        soft-wrap.enable = true;
        file-picker.hidden = false;
        shell = ["nu" "--stdin" "--commands"];
      };

      keys.normal = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
        space.w = ":write";
        space.x = ":buffer-close";
        space.q = ":quit";
        space.l = ":format";
        C-h = ":toggle lsp.display-inlay-hints";
      };

      keys.select = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
      };
    };

    languages = {
      language = [
        {
          name = "css";
          formatter = {
            command = "prettier";
            args = ["--parser" "css"];
          };
          auto-format = false;
        }
        {
          name = "html";
          formatter = {
            command = "prettier";
            args = ["--parser" "html"];
          };
          auto-format = false;
        }
        {
          name = "javascript";
          formatter = {
            command = "deno";
            args = ["fmt" "-" "--line-width" "120" "--ext" "js"];
          };
          auto-format = false;
        }
        {
          name = "json";
          formatter = {
            command = "deno";
            args = ["fmt" "-" "--line-width" "120" "--ext" "json"];
          };
          auto-format = false;
        }
        {
          name = "jsx";
          formatter = {
            command = "deno";
            args = ["fmt" "-" "--line-width" "120" "--ext" "jsx"];
          };
          auto-format = false;
        }
        {
          name = "markdown";
          language-servers = ["marksman" "ltex-ls"];
        }
        {
          name = "nix";
          formatter.command = "alejandra";
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "tailwindcss-ls"];
        }
        {
          name = "tsx";
          formatter = {
            command = "deno";
            args = ["fmt" "-" "--line-width" "120" "--ext" "tsx"];
          };
          auto-format = false;
        }
        {
          name = "typescript";
          formatter = {
            command = "deno";
            args = ["fmt" "-" "--line-width" "120" "--ext" "ts"];
          };
          auto-format = false;
        }
        {
          name = "yaml";
          formatter = {
            command = "prettier";
            args = ["--parser" "yaml"];
          };
          auto-format = false;
        }
      ];

      language-server = {
        rust-analyzer.config.check.command = "clippy";
        tailwindcss-ls.config.userLanguages = {
          rust = "html";
          "*.rs" = "html";
        };
      };
    };

    extraPackages = [
      # TODO: move to nix devshell
      pkgs.alejandra
      pkgs.nil

      # misc
      pkgs.ltex-ls # grammar & spelling
      pkgs.marksman # markdown
      pkgs.taplo # toml
      pkgs.vscode-langservers-extracted # css, html, javascript, json, jsx
      pkgs.yaml-language-server # yaml
      pkgs.deno # formatters
      pkgs.nodePackages.prettier # formatters

      # TODO: move to lua devshell
      pkgs.lua-language-server

      # TODO: move to ts devshell
      pkgs.typescript-language-server
      pkgs.tailwindcss-language-server

      # TODO: move to docker devshell
      pkgs.docker-compose-language-service
      pkgs.dockerfile-language-server-nodejs
    ];
  };
}
