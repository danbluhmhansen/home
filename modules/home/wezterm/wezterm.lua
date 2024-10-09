local config = wezterm.config_builder()

local shell = wezterm.target_triple == 'aarch64-apple-darwin' and '/bin/zsh' or '/bin/bash';

config.default_prog = { shell, '-ci', 'nu' }

config.launch_menu = {
  wezterm.run_child_process { shell, '-c', 'which broot' } and
  { label = 'broot', args = { shell, '-ci', 'nu --execute br' }, cwd = '~', } or {},
  wezterm.run_child_process { shell, '-c', 'which yazi' } and
  { label = 'yazi', args = { shell, '-ci', 'nu --execute yy' }, cwd = '~', } or {},
  { label = 'sh', args = { shell }, },
  wezterm.run_child_process { shell, '-c', 'which btm' } and
  { label = 'bottom', args = { shell, '-ci', 'btm' }, cwd = '~', } or {},
}

-- wezterm.gui is not available to the mux server, so take care to do something reasonable when this config is evaluated
-- by the mux
local function get_appearance()
  return wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
end

local function scheme_for_appearance(appearance)
  return appearance:find 'Dark' and 'Catppuccin Mocha' or 'Catppuccin Latte'
end

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'br' then
    local ex_pane = pane:tab():get_pane_direction('Right')
    if ex_pane then
      local proc_info = ex_pane:get_foreground_process_info()
      if proc_info.name == 'hx' then
        ex_pane:send_text(':o ' .. value)
        ex_pane:activate()
      end
      if proc_info.name == 'bash' or proc_info.name == 'nu' or proc_info.name == 'zsh' then
        ex_pane:send_text('hx ' .. value)
        ex_pane:activate()
      end
    else
      local dims = pane:get_dimensions()
      local pos = value:find('␟')
      local dir = value:sub(1, pos - 1)
      local file = value:sub(pos + 3, -1)
      wezterm.log_info('br dir', dir)
      wezterm.log_info('br file', file)
      pane:split {
        args = { shell, '-ci', 'nu --execute "hx ' .. file .. '"' },
        direction = 'Right',
        size = dims.cols - 36,
        -- NOTE: cwd does not currently work?
        cwd = dir,
      }
    end
  end
end)

wezterm.on('update-right-status', function(window, pane)
  local scheme = wezterm.get_builtin_color_schemes()[scheme_for_appearance(get_appearance())]

  local status = {}

  -- Figure out the cwd and host of the current pane. This will pick up the hostname for the remote host if your shell
  -- is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path

    local _, git_branch, _ = wezterm.run_child_process { shell, '-c', 'starship module git_branch --path ' .. cwd, }
    local _, git_status, _ = wezterm.run_child_process { shell, '-c', 'starship module git_status --path ' .. cwd, }
    local directory = cwd:gsub(wezterm.home_dir, '~')
    local hostname = cwd_uri.host or wezterm.hostname()

    if git_branch ~= '' then
      table.insert(status, wezterm.format { { Foreground = { Color = scheme.ansi[6] } }, { Text = git_branch } })
    end
    if git_status ~= '' then
      table.insert(status, wezterm.format { { Foreground = { Color = scheme.ansi[2] } }, { Text = git_status } })
    end
    table.insert(status, wezterm.format { { Foreground = { Color = scheme.ansi[7] } }, { Text = directory } })
    table.insert(status, wezterm.format { { Foreground = { Color = scheme.ansi[3] } }, { Text = hostname } })
  end

  local date = wezterm.strftime '%a %b %-d %T'
  table.insert(status, wezterm.format { { Foreground = { Color = scheme.ansi[4] } }, { Text = date } })

  window:set_right_status(table.concat(status, ' '))
end)

config.native_macos_fullscreen_mode = true

config.color_scheme = scheme_for_appearance(get_appearance())

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

if wezterm.target_triple == 'aarch64-apple-darwin' then
  config.font_size = 16
end
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
        command = { args = { shell, '-ci', 'nu --execute br' } },
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
