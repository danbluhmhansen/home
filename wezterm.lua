local config = wezterm.config_builder()

config.default_prog = { '/bin/zsh', '-c', '/etc/profiles/per-user/dan/bin/nu' }

config.launch_menu = {
  {
    label = 'broot',
    args = { '/bin/zsh', '-c', '/etc/profiles/per-user/dan/bin/broot' },
    cwd = "~",
  },
  {
    label = 'bottom',
    args = { '/bin/zsh', '-c', '/etc/profiles/per-user/dan/bin/btm' },
    cwd = "~",
  },
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
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  local scheme = wezterm.get_builtin_color_schemes()[scheme_for_appearance(get_appearance())]

  -- Color palette for the backgrounds of each cell
  local colors = {
    scheme.tab_bar.background,
    scheme.tab_bar.inactive_tab.bg_color,
    scheme.tab_bar.inactive_tab_hover.bg_color,
    scheme.tab_bar.new_tab.bg_color,
    scheme.tab_bar.new_tab_hover.bg_color,
  }

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = wezterm.target_triple == 'x86_64-pc-windows-msvc' and cwd_uri.file_path:sub(2) or cwd_uri.file_path
    local hostname = cwd_uri.host or wezterm.hostname()

    -- Remove the domain name portion of the hostname
    local dot = hostname:find '[.]'
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    local home = cwd:gsub(wezterm.home_dir:gsub('\\', '/'), '~')

    local _, git_branch, _ = wezterm.run_child_process {
      '/bin/zsh',
      '-c',
      '/etc/profiles/per-user/dan/bin/starship module git_branch --path ' .. cwd,
    }

    local _, git_status, _ = wezterm.run_child_process {
      '/bin/zsh',
      '-c',
      '/etc/profiles/per-user/dan/bin/starship module git_status --path ' .. cwd,
    }

    table.insert(cells, git_branch .. git_status)
    table.insert(cells, home)
    table.insert(cells, hostname)
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime '%F %T'
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  -- for _, b in ipairs(wezterm.battery_info()) do
  --   table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  -- end

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = scheme.foreground } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
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

if wezterm.hostname() == 'jupiter.local' then
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
        command = { args = { '/bin/zsh', '-c', '/etc/profiles/per-user/dan/bin/broot' } },
        direction = 'Left',
        size = { Cells = 36 },
      }, pane)
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

if wezterm.hostname() == 'venus.local' then
  table.insert(keys, { key = '§', action = act.SendKey { key = '`' } })
  table.insert(keys, { key = '±', action = act.SendKey { key = '~' } })
  table.insert(keys, { key = '`', action = act.SendKey { key = '§' } })
  table.insert(keys, { key = '~', action = act.SendKey { key = '±' } })
end

config.keys = keys

return config
