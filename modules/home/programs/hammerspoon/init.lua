hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()

local darkmode_watcher = hs.distributednotifications.new(function()
  local _, darkmode, _ = hs.osascript.applescript(
    'tell application "System Events" to tell appearance preferences to return dark mode')
  local file = io.open(os.getenv('HOME') .. '/.config/helix/themes/theme.toml', 'w')
  if (file) then
    if darkmode then
      file:write('inherits = "catppuccin_mocha"')
    else
      file:write('inherits = "catppuccin_latte"')
    end
    file:close()
    hs.execute('pkill -USR1 hx')
  end
end, 'AppleInterfaceThemeChangedNotification')

darkmode_watcher:start()

local pass_chooser = hs.chooser.new(function(choice)
  if (choice) then
    hs.execute('gopass show --clip ' .. choice.text, true)
  end
end)

pass_chooser:choices(function()
  local out, status = hs.execute('gopass ls --flat', true)
  if (status) then
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
PaperWM:bindHotkeys(PaperWM.default_hotkeys)
PaperWM:start()
