{pkgs, ...}: {
  programs.helix = {
    defaultEditor = true;

    settings = rec {
      theme = pkgs.lib.mkDefault "catppuccin_mocha";
      editor = {
        shell = ["nu" "--commands"];
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;
        text-width = 120;
        rainbow-brackets = true;

        statusline = {
          left = ["mode" "spinner" "diagnostics" "workspace-diagnostics"];
          center = ["read-only-indicator" "file-name" "file-modification-indicator"];
          right = ["zoom" "position" "position-percentage" "primary-selection-length" "register" "file-encoding"];
          merge-with-commandline = true;
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
        auto-pairs."(" = ")";
        auto-pairs."{" = "}";
        auto-pairs."[" = "]";

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

        inline-blame = {
          show = "cursor-line";
          auto-fetch = true;
          format = "{author}, {time-ago} • {commit} • {title}";
        };
      };

      keys.normal = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
        C-h = ":toggle lsp.display-inlay-hints";
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";

        space = {
          w = ":write";
          x = ":buffer-close";
          q = ":quit";
          l = ":format";
          F = "file_picker_in_current_buffer_directory";
          z = ":set-max-width 120 0";

          e = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output yazi --chooser-file=/tmp/unique-file"
            ":insert-output echo $'(ansi -e ?1049h)(ansi -e ?2004h)' o> /dev/tty"
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
            ":set mouse false"
            ":set mouse true"
          ];
          E = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
            ":insert-output echo $'(ansi -e ?1049h)(ansi -e ?2004h)' o> /dev/tty"
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
            ":set mouse false"
            ":set mouse true"
          ];

          v = [
            ":insert-output lazygit"
            ":insert-output echo $'(ansi -e ?1049h)(ansi -e ?2004h)' o> /dev/tty"
            ":redraw"
            ":set mouse false"
            ":set mouse true"
            ":reload-all"
          ];
        };
      };
      keys.insert = {
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";
        A-tab = "insert_tab";
      };
      keys.select = keys.normal;
    };

    languages = {
      language = let
        denoFmt = name: ["fmt" "-" "--line-width" "120" "--ext" name];
      in [
        {
          name = "c-sharp";
          formatter.command = "dotnet";
          formatter.args = ["csharpier" "format"];
          auto-format = false;
          language-servers = ["csharp"];
        }
        rec {
          name = "css";
          formatter.command = "deno";
          formatter.args = denoFmt name;
          auto-format = false;
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
        }
        rec {
          name = "html";
          formatter.command = "deno";
          formatter.args = denoFmt name;
          auto-format = false;
          language-servers = ["vscode-html-language-server" "superhtml" "tailwindcss-ls"];
        }
        {
          name = "javascript";
          formatter.command = "deno";
          formatter.args = denoFmt "js";
          auto-format = false;
        }
        rec {
          name = "json";
          formatter.command = "deno";
          formatter.args = denoFmt name;
          auto-format = false;
        }
        rec {
          name = "jsx";
          formatter.command = "deno";
          formatter.args = denoFmt name;
          auto-format = false;
        }
        {
          name = "markdown";
          formatter.command = "deno";
          formatter.args = denoFmt "md";
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
          name = "sql";
          formatter.command = "sqruff";
          formatter.args = ["fix" "-"];
          language-servers = ["postgrestools" "sqruff"];
        }
        rec {
          name = "tsx";
          formatter.command = "deno";
          formatter.args = denoFmt name;
          auto-format = false;
        }
        {
          name = "typescript";
          formatter.command = "deno";
          formatter.args = denoFmt "ts";
          auto-format = false;
        }
      ];

      language-server = {
        csharp.command = "csharp-language-server";
        rust-analyzer.config.check.command = "clippy";
        tailwindcss-ls.config.userLanguages = {
          html = "html";
          rust = "html";
        };
        postgrestools = {
          command = "postgrestools";
          args = ["lsp-proxy"];
        };
        sqruff = {
          command = "sqruff";
          args = ["lsp"];
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
      yamlfmt # yaml
      deno # formatters
    ];
  };
}
