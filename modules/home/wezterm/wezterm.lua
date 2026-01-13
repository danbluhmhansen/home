local config = wezterm.config_builder()

local shell = wezterm.target_triple == 'aarch64-apple-darwin' and 'zsh' or 'bash'

config.default_prog = { shell, '-ci', 'nu' }

config.launch_menu = {
  { label = 'yazi',   args = { shell, '-ci', 'nu --execute yy' }, cwd = wezterm.home_dir },
  { label = 'bottom', args = { 'btm' },                           cwd = wezterm.home_dir },
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
    local pos = value:find('␟')
    local dir = value:sub(1, pos - 1)
    local file = value:sub(pos + 3, -1)

    local ex_pane = pane:tab():get_pane_direction('Right')
    if ex_pane then
      local proc_info = ex_pane:get_foreground_process_info()
      if proc_info.name == 'hx' then
        ex_pane:send_text(':o ' .. file)
        ex_pane:activate()
      end
      if proc_info.name == 'bash' or proc_info.name == 'zsh' then
        ex_pane:send_text('cd ' .. dir .. ' && $EDITOR ' .. file .. '\n')
        ex_pane:activate()
      end
      if proc_info.name == 'nu' then
        ex_pane:send_text('cd ' .. dir .. ';nu --commands $"($env.EDITOR) ' .. file .. '"\n')
        ex_pane:activate()
      end
    else
      pane:split({
        args = { shell, '-ci', 'nu --execute "$env.EDITOR ' .. file .. '"' },
        direction = 'Right',
        size = pane:get_dimensions().cols - 36,
        -- NOTE: cwd does not currently work?
        cwd = dir,
      })
    end
  end
end)

wezterm.on('update-right-status', function(window, pane)
  local status = {}
  -- Figure out the cwd and host of the current pane. This will pick up the hostname for the remote host if your shell
  -- is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path
    local _, prompt, _ = wezterm.run_child_process({ 'sh', '-ci',
      'TERM=xterm-256color starship prompt --profile wz --path ' .. cwd })
    table.insert(status, prompt)
  end
  window:set_right_status(table.concat(status, ' '))
end)

config.native_macos_fullscreen_mode = true

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

config.window_close_confirmation = 'NeverPrompt'

config.enable_kitty_keyboard = true

if wezterm.target_triple == 'aarch64-apple-darwin' then
  config.color_scheme = scheme_for_appearance(get_appearance())
  config.font_size = 15
  config.window_padding = {
    left   = 8,
    right  = 0,
    top    = 0,
    bottom = 0,
  }
end

local act = wezterm.action

local keys = {}

table.insert(keys, {
  key    = 'h',
  mods   = 'ALT',
  action = act.ActivatePaneDirection('Left'),
})
table.insert(keys, {
  key    = 'j',
  mods   = 'ALT',
  action = act.ActivatePaneDirection('Down'),
})
table.insert(keys, {
  key    = 'k',
  mods   = 'ALT',
  action = act.ActivatePaneDirection('Up'),
})
table.insert(keys, {
  key    = 'l',
  mods   = 'ALT',
  action = act.ActivatePaneDirection('Right'),
})

table.insert(keys, {
  key    = 'e',
  mods   = 'SHIFT|CTRL',
  action = act.ShowLauncher,
})
table.insert(keys, {
  key    = 'e',
  mods   = 'SUPER',
  action = act.ShowLauncher,
})

local br_act = wezterm.action_callback(function(window, pane)
  local proc_info = pane:get_foreground_process_info()
  if proc_info.name == '.broot-wrapped' then
    local main_pane = pane:tab():get_pane_direction('Right')
    if main_pane ~= nil then
      window:perform_action(act.ActivatePaneDirection('Right'), pane)
      window:perform_action(act.TogglePaneZoomState, main_pane)
    end
  else
    local br_pane = pane:tab():get_pane_direction('Left')
    if br_pane == nil then
      window:perform_action(
        act.SplitPane({
          command = { args = { shell, '-ci', 'nu --execute br' } },
          direction = 'Left',
          size = { Cells = 36 },
        }),
        pane
      )
    else
      window:perform_action(act.TogglePaneZoomState, pane)
    end
  end
end)
table.insert(keys, {
  key    = 'b',
  mods   = 'SHIFT|CTRL',
  action = br_act,
})
table.insert(keys, {
  key    = 'b',
  mods   = 'SUPER',
  action = br_act,
})

config.keys = keys

return config
