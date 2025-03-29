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

wezterm.on('update-right-status', function(window, pane)
  local status = {}

  -- Figure out the cwd and host of the current pane. This will pick up the hostname for the remote host if your shell
  -- is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path
    local _, prompt, _ = wezterm.run_child_process { shell, '-c', 'starship prompt --profile wz --path ' .. cwd, }
    table.insert(status, prompt)
  end

  window:set_right_status(table.concat(status, ' '))
end)

wezterm.on('window-config-reloaded', function()
  local file = io.open(wezterm.home_dir .. '/.config/helix/themes/theme.toml', 'w')
  if (file) then
    if get_appearance() == 'Dark' then
      file:write('inherits = "catppuccin_mocha"')
    else
      file:write('inherits = "catppuccin_latte"')
    end
    file:close()
    wezterm.run_child_process { shell, '-c', 'pkill -USR1 hx' }
  end
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
  harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', },
}

config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

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

config.keys = keys

return config
