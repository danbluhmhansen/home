{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "theme";

      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;
        text-width = 120;

        statusline = {
          left = ["mode" "spinner" "diagnostics" "workspace-diagnostics"];
          center = ["read-only-indicator" "file-name" "file-modification-indicator"];
          right = ["position" "position-percentage" "primary-selection-length" "register" "file-encoding"];
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
        inline-diagnostics.cursor-line = "hint";
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
        space.e = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi --chooser-file=/tmp/unique-file"
          '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
          ":set mouse false"
          ":set mouse true"
        ];
        space.E = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
          ":set mouse false"
          ":set mouse true"
        ];
        space.v.s = ":run-shell-command git status";
        space.v.f = ":run-shell-command git fetch";
        space.v.F = ":run-shell-command git fetch --all";
        space.v.a = ":run-shell-command git add %{buffer_name}";
        space.v.b = ":run-shell-command git blame -L %{cursor_line} %{buffer_name}";
        space.v.B = ":run-shell-command git blame %{buffer_name}";
        space.v.d = ":run-shell-command git diff %{buffer_name}";
        space.v.l = ":run-shell-command git log -- %{buffer_name}";
        space.v.L = ":run-shell-command git log --patch -- %{buffer_name}";
      };

      keys.insert = {
        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";
        A-tab = "insert_tab";
      };

      keys.select = {
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
        space.e = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi --chooser-file=/tmp/unique-file"
          '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
          ":set mouse false"
          ":set mouse true"
        ];
        space.E = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
          ":set mouse false"
          ":set mouse true"
        ];
        space.v.s = ":run-shell-command git status";
        space.v.f = ":run-shell-command git fetch";
        space.v.F = ":run-shell-command git fetch --all";
        space.v.a = ":run-shell-command git add %{buffer_name}";
        space.v.b = ":run-shell-command git blame -L %{cursor_line} %{buffer_name}";
        space.v.B = ":run-shell-command git blame %{buffer_name}";
        space.v.d = ":run-shell-command git diff %{buffer_name}";
        space.v.l = ":run-shell-command git log -- %{buffer_name}";
        space.v.L = ":run-shell-command git log --patch -- %{buffer_name}";
      };
    };

    languages = {
      language = [
        {
          name = "c-sharp";
          formatter.command = "dotnet";
          formatter.args = ["csharpier" "format"];
          auto-format = false;
          language-servers = ["csharp"];
        }
        {
          name = "css";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "css"];
          auto-format = false;
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
        }
        {
          name = "html";
          formatter.command = "deno";
          formatter.args = ["fmt" "-" "--line-width" "120" "--ext" "html"];
          auto-format = false;
          language-servers = ["vscode-html-language-server" "superhtml" "tailwindcss-ls"];
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
          name = "sql";
          language-servers = ["postgrestools"];
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
        # {
        #   name = "yaml";
        #   formatter.command = "prettier";
        #   formatter.args = ["--parser" "yaml"];
        #   auto-format = false;
        # }
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
    ];
  };
}
