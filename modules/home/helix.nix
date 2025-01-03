{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    defaultEditor = true;

    settings = {
      theme = "theme";

      editor = {
        shell = ["nu" "--stdin" "--commands"];
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;
        text-width = 120;
        end-of-line-diagnostics = "info";

        statusline = {
          left = ["mode" "spinner" "diagnostics" "workspace-diagnostics"];
          center = ["read-only-indicator" "file-name" "file-modification-indicator"];
          right = ["position" "position-percentage" "primary-selection-length" "register" "file-encoding"];
        };

        lsp = {
          display-messages = true;
          goto-reference-include-declaration = false;
        };

        cursor-shape = {
          insert = "bar";
          select = "underline";
        };

        file-picker.hidden = false;
        auto-pairs = false;

        whitespace = {
          render.tab = "all";
          render.nbsp = "all";
          render.nnbsp = "all";
          characters.space = "·";
          characters.nbsp = "⍽";
          characters.nnbsp = "␣";
          characters.tab = "→";
          characters.newline = "⏎";
          characters.tabpad = "·";
        };

        indent-guides.render = true;
        soft-wrap.enable = true;
        inline-diagnostics.cursor-line = "warning";
      };

      keys.normal = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
        C-h = ":toggle lsp.display-inlay-hints";
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";
        space.w = ":write";
        space.x = ":buffer-close";
        space.q = ":quit";
        space.l = ":format";
        space.F = "file_picker_in_current_buffer_directory";
      };

      keys.insert = {
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";
        A-tab = "insert_tab";
      };

      keys.select = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";
      };
    };

    languages = {
      language = [
        {
          name = "css";
          formatter.command = "prettier";
          formatter.args = ["--parser" "css"];
          auto-format = false;
        }
        {
          name = "html";
          formatter.command = "prettier";
          formatter.args = ["--parser" "html"];
          auto-format = false;
        }
        {
          name = "javascript";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "js"];
          auto-format = false;
        }
        {
          name = "json";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "json"];
          auto-format = false;
        }
        {
          name = "jsx";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "jsx"];
          auto-format = false;
        }
        {
          name = "markdown";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "md"];
          language-servers = ["marksman" "ltex-ls"];
        }
        {
          name = "nix";
          formatter.command = "alejandra";
        }
        {
          name = "python";
          formatter.command = "ruff";
          formatter.args = ["format" "--line-length" "120" "-"];
          auto-format = false;
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "tailwindcss-ls"];
        }
        {
          name = "tsx";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "tsx"];
          auto-format = false;
        }
        {
          name = "typescript";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "ts"];
          auto-format = false;
        }
        {
          name = "yaml";
          formatter.command = "prettier";
          formatter.args = ["--parser" "yaml"];
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

    extraPackages = with pkgs; [
      dockerfile-language-server-nodejs # dockerfile
      docker-compose-language-service # docker-compose
      ltex-ls # grammar & spelling
      marksman # markdown
      taplo # toml
      vscode-langservers-extracted # css, html, javascript, json, jsx
      yaml-language-server # yaml
      deno # formatters
      nodePackages.prettier # formatters
    ];
  };
}
