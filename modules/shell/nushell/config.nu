$env.config.show_banner = false

$env.config.edit_mode = "helix"

$env.config.cursor_shape.helix_normal = "blink_block"
$env.config.cursor_shape.helix_select = "blink_underscore"
$env.config.cursor_shape.helix_insert = "blink_line"

$env.config.explore.status_bar_background = { fg: white, bg: black }
$env.config.explore.command_bar_text = { fg: white }
$env.config.explore.highlight = { fg: black, bg: yellow }
$env.config.explore.status.error = { fg: red }
$env.config.explore.selected_cell = { bg: black }

$env.config.use_kitty_protocol = true

if (sys host | get hostname) == 'mars' {
  $env.config.shell_integration.osc133 = false;
}

# Lazy-loaded starship prompt
export-env { $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^starship prompt --continuation
    )

    PROMPT_COMMAND: {
        let jobs = (
            if (which "job list" | where type == built-in | is-not-empty) {
                ["--jobs", (job list | where description != "starship-prompt" | length)]
            } else {
                []
            }
        )
        job spawn --description "starship-prompt" {
            # The initial value of `$env.CMD_DURATION_MS` is always `0823`, which is an official setting.
            # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            let p = (^starship prompt
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...$jobs
            )
            # External output capture strips the trailing newline, and reedline
            # puts the input on the last line of the pushed prompt. Re-add the
            # break unless starship already emitted content on a following line
            # (e.g. the jobs symbol), which should share the line with the
            # input indicator.
            commandline set-prompt (if ($p | str contains "\n") { $p } else { $p + "\n" })
        }
        ""
    }

    PROMPT_COMMAND_RIGHT: {
        let jobs = (
            if (which "job list" | where type == built-in | is-not-empty) {
                ["--jobs", (job list | where description != "starship-prompt" | length)]
            } else {
                []
            }
        )
        job spawn --description "starship-prompt" {
            # The initial value of `$env.CMD_DURATION_MS` is always `0823`, which is an official setting.
            # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            let p = (^starship prompt
                --right
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...$jobs
            )
            commandline set-prompt --right $p
        }
        ""
    }
}}
