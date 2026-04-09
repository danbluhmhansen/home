{inputs, ...}: {
  flake.modules.homeManager.helix = {
    pkgs,
    lib,
    ...
  }: {
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultEditor = true;

      settings = rec {
        theme.dark = "catppuccin_mocha";
        theme.light = "catppuccin_latte";
        editor = {
          shell = ["${lib.getExe pkgs.nushell}" "--stdin" "--commands"];
          line-number = "relative";
          cursorline = true;
          bufferline = "multiple";
          color-modes = true;
          text-width = 120;
          rainbow-brackets = true;

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
        };

        keys.normal = {
          H = "goto_first_nonwhitespace";
          L = "goto_line_end";
          C-h = ":toggle lsp.display-inlay-hints";
          tab = "move_parent_node_end";
          S-tab = "move_parent_node_start";

          "`" = {
            c = ":pipe str camel-case";
            l = ":pipe str downcase";
            k = ":pipe str kebab-case";
            p = ":pipe str pascal-case";
            s = ":pipe str snake-case";
            t = ":pipe str title-case";
            u = ":pipe str upcase";
            e = {
              "3" = ":pipe encode base32";
              "6" = ":pipe encode base64";
              h = ":pipe encode hex";
              u = ":pipe url encode";
            };
            d = {
              "3" = ":pipe decode base32 | decode";
              "6" = ":pipe decode base64 | decode";
              h = ":pipe decode hex | decode";
              u = ":pipe url decode";
            };
            h = {
              m = ":pipe hash md5";
              s = ":pipe hash sha256";
            };
            r = {
              c = ":insert-output random chars";
              f = ":insert-output random float";
              i = ":insert-output random int";
              u = ":insert-output random uuid";
              "4" = ":insert-output random uuid --version 4";
              "7" = ":insert-output random uuid --version 7";
            };
          };

          space = {
            w = ":write";
            x = ":buffer-close";
            q = ":quit";
            "=" = ":format";
            F = "file_picker_in_current_buffer_directory";
            E = "file_explorer_in_current_buffer_directory";
          };
        };
        keys.select = keys.normal;
      };

      languages = {
        language = let
          denoFmt = name: ["fmt" "-" "--line-width" "120" "--ext" name];
        in [
          {
            name = "c-sharp";
            formatter.command = "csharpier";
            formatter.args = ["format"];
            auto-format = false;
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
            language-servers = ["superhtml" "tailwindcss-ls"];
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
        ltex-ls # grammar & spelling
        marksman # markdown
        taplo # toml
        yaml-language-server # yaml
        yamlfmt # yaml
        deno # formatters
      ];
    };
  };
}
