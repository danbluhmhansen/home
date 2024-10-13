hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()

local pass_chooser = hs.chooser.new(function(choice)
  if choice then
    hs.execute('gopass show --clip ' .. choice.text, true)
  end
end)

pass_chooser:choices(function()
  local out, status = hs.execute('gopass ls --flat', true)
  if status then
    local t = {}
    for str in string.gmatch(out, '([^%s]+)') do
      table.insert(t, { ['text'] = str })
    end
    return t
  else
    return 'No passwords...'
  end
end)

hs.hotkey.bind({ 'cmd', 'ctrl' }, 'P', function()
  pass_chooser:show()
end)

PaperWM = hs.loadSpoon("PaperWM")
PaperWM.window_ratios = { 0.33333, 0.5, 0.66666 }
PaperWM.window_gap = 6
PaperWM:bindHotkeys({
  stop_events          = { { "alt", "cmd", "shift" }, "q" },
  refresh_windows      = { { "alt", "cmd", "shift" }, "escape" },

  -- switch to a new focused window in tiled grid
  focus_left           = { { "alt", "cmd" }, "h" },
  focus_down           = { { "alt", "cmd" }, "j" },
  focus_up             = { { "alt", "cmd" }, "k" },
  focus_right          = { { "alt", "cmd" }, "l" },

  -- move windows around in tiled grid
  swap_left            = { { "alt", "cmd", "shift" }, "h" },
  swap_down            = { { "alt", "cmd", "shift" }, "j" },
  swap_up              = { { "alt", "cmd", "shift" }, "k" },
  swap_right           = { { "alt", "cmd", "shift" }, "l" },

  -- position and resize focused window
  center_window        = { { "alt", "cmd" }, "c" },
  full_width           = { { "alt", "cmd" }, "f" },
  cycle_width          = { { "alt", "cmd" }, "r" },
  cycle_height         = { { "alt", "cmd", "shift" }, "r" },
  reverse_cycle_width  = { { "ctrl", "alt", "cmd" }, "r" },
  reverse_cycle_height = { { "ctrl", "alt", "cmd", "shift" }, "r" },

  -- move focused window into / out of a column
  slurp_in             = { { "alt", "cmd" }, "i" },
  barf_out             = { { "alt", "cmd" }, "o" },

  -- move the focused window into / out of the tiling layer
  toggle_floating      = { { "alt", "cmd", "shift" }, "space" },

  -- switch to a new Mission Control space
  switch_space_l       = { { "alt", "cmd" }, "," },
  switch_space_r       = { { "alt", "cmd" }, "." },
  switch_space_1       = { { "alt", "cmd" }, "1" },
  switch_space_2       = { { "alt", "cmd" }, "2" },
  switch_space_3       = { { "alt", "cmd" }, "3" },
  switch_space_4       = { { "alt", "cmd" }, "4" },
  switch_space_5       = { { "alt", "cmd" }, "5" },
  switch_space_6       = { { "alt", "cmd" }, "6" },
  switch_space_7       = { { "alt", "cmd" }, "7" },
  switch_space_8       = { { "alt", "cmd" }, "8" },
  switch_space_9       = { { "alt", "cmd" }, "9" },

  -- move focused window to a new space and tile
  move_window_1        = { { "alt", "cmd", "shift" }, "1" },
  move_window_2        = { { "alt", "cmd", "shift" }, "2" },
  move_window_3        = { { "alt", "cmd", "shift" }, "3" },
  move_window_4        = { { "alt", "cmd", "shift" }, "4" },
  move_window_5        = { { "alt", "cmd", "shift" }, "5" },
  move_window_6        = { { "alt", "cmd", "shift" }, "6" },
  move_window_7        = { { "alt", "cmd", "shift" }, "7" },
  move_window_8        = { { "alt", "cmd", "shift" }, "8" },
  move_window_9        = { { "alt", "cmd", "shift" }, "9" }
})
PaperWM:start()
