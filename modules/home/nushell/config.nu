$env.config.show_banner = false
$env.config.explore = {
  status_bar_background: { fg: white, bg: black },
  command_bar_text: { fg: white },
  highlight: { fg: black, bg: yellow },
  status: {
      error: { fg: red },
      warn: {}
      info: {}
  },
  selected_cell: { bg: black },
}
$env.config.filesize.metric = true
$env.config.use_kitty_protocol = true
$env.config.hooks = {
  pre_execution: [
    {
      condition: {|| (sys host | get name) == 'Darwin' and (defaults read -g AppleInterfaceStyle | complete | get exit_code) == 0 }
      code: {|| load-env { LS_COLORS: (vivid generate catppuccin-mocha) } }
    }
    {
      condition: {|| (sys host | get name) == 'Darwin' and (defaults read -g AppleInterfaceStyle | complete | get exit_code) == 1 }
      code: {|| load-env { LS_COLORS: (vivid generate catppuccin-latte) } }
    }
  ]
}
