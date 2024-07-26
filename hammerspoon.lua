hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()

local darkmode_watcher = hs.distributednotifications.new(function(name, object, userInfo)
  local _, darkmode, _ = hs.osascript.applescript(
    'tell application "System Events" to tell appearance preferences to return dark mode')
  local file = io.open(os.getenv('HOME') .. '/.config/helix/themes/theme.toml', "w")
  if darkmode then
    file:write('inherits = "catppuccin_mocha"')
  else
    file:write('inherits = "catppuccin_latte"')
  end
  file:close()
  hs.execute("pkill -USR1 hx")
end, 'AppleInterfaceThemeChangedNotification')

darkmode_watcher:start()
