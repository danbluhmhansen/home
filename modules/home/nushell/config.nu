$env.config.show_banner = false

$env.config.explore.status_bar_background = { fg: white, bg: black }
$env.config.explore.command_bar_text = { fg: white }
$env.config.explore.highlight = { fg: black, bg: yellow }
$env.config.explore.status.error = { fg: red }
$env.config.explore.selected_cell = { bg: black }

$env.config.use_kitty_protocol = true

if (sys host | get name) == 'Darwin' {
  $env.config.hooks.pre_execution = [
    {
      load-env {
        LS_COLORS: (
          if (defaults read -g AppleInterfaceStyle | complete | get exit_code) == 0 {
            (vivid generate catppuccin-mocha)
          } else {
            (vivid generate catppuccin-latte)
          }
        )
      }
    }
  ]
}
