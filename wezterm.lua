local config = wezterm.config_builder()

local shell = '/bin/zsh'

config.default_prog = { shell, '-c', 'nu' }

config.launch_menu = {
  { label = 'bottom', args = { shell, '-c', 'btm' },             cwd = '~', },
  { label = 'broot',  args = { shell, '-c', 'nu --execute br' }, cwd = '~', },
  { label = 'sh',     args = { shell }, },
}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

wezterm.on('update-right-status', function(window, pane)
  local scheme = wezterm.get_builtin_color_schemes()[scheme_for_appearance(get_appearance())]

  local status = ''

  -- Figure out the cwd and host of the current pane. This will pick up the hostname for the remote host if your shell
  -- is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path

    local _, git_branch, _ = wezterm.run_child_process { shell, '-c', 'starship module git_branch --path ' .. cwd, }
    local _, git_status, _ = wezterm.run_child_process { shell, '-c', 'starship module git_status --path ' .. cwd, }
    local directory = cwd:gsub(wezterm.home_dir, '~')
    local hostname = cwd_uri.host or wezterm.hostname()

    status = status .. wezterm.format { { Foreground = { Color = scheme.ansi[6] } }, { Text = git_branch .. ' ' } }
    status = status .. wezterm.format { { Foreground = { Color = scheme.ansi[2] } }, { Text = git_status .. ' ' } }
    status = status .. wezterm.format { { Foreground = { Color = scheme.ansi[7] } }, { Text = directory .. ' ' } }
    status = status .. wezterm.format { { Foreground = { Color = scheme.ansi[3] } }, { Text = hostname .. ' ' } }
  end

  local date = wezterm.strftime '%a %b %-d %T'
  status = status .. wezterm.format { { Foreground = { Color = scheme.ansi[4] } }, { Text = date } }

  window:set_right_status(status)
end)

config.native_macos_fullscreen_mode = true

config.color_scheme = scheme_for_appearance(get_appearance())

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

config.font_size = 16
config.font = wezterm.font {
  family = 'Maple Mono NF',
  harfbuzz_features = { 'cv01', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', },
}

config.window_close_confirmation = 'NeverPrompt'

config.enable_kitty_keyboard = true

if wezterm.target_triple == 'aarch64-apple-darwin' then
  config.window_padding = {
    left = 8,
    right = 0,
    top = 0,
    bottom = 0,
  }
end

local act = wezterm.action

local keys = {}

table.insert(keys, {
  key = 'h',
  mods = 'ALT',
  action = act.ActivatePaneDirection 'Left',
})
table.insert(keys, {
  key = 'j',
  mods = 'ALT',
  action = act.ActivatePaneDirection 'Down',
})
table.insert(keys, {
  key = 'k',
  mods = 'ALT',
  action = act.ActivatePaneDirection 'Up',
})
table.insert(keys, {
  key = 'l',
  mods = 'ALT',
  action = act.ActivatePaneDirection 'Right',
})

table.insert(keys, {
  key = 'e',
  mods = 'SHIFT|CTRL',
  action = act.ShowLauncher,
})
table.insert(keys, {
  key = 'e',
  mods = 'SUPER',
  action = act.ShowLauncher,
})

local br_act = wezterm.action_callback(function(win, pane)
  local br_pane = pane:tab():get_pane_direction('Left')
  if (br_pane == nil) then
    win:perform_action(
      act.SplitPane {
        command = { args = { shell, '-c', 'nu --execute br' } },
        direction = 'Left',
        size = { Cells = 36 },
      },
      pane
    )
  else
    br_pane:activate()
    win:perform_action(act.CloseCurrentPane { confirm = true }, pane)
  end
end)
table.insert(keys, {
  key = 'b',
  mods = 'SHIFT|CTRL',
  action = br_act,
})
table.insert(keys, {
  key = 'b',
  mods = 'SUPER',
  action = br_act,
})

config.keys = keys

return config
