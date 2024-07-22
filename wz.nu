def main [file: string] {
    try {
      let pane_id = wezterm cli get-pane-direction right | into int
      let pane = wezterm cli list --format json | from json | where pane_id == $pane_id | first
      wezterm cli send-text --no-paste --pane-id $pane_id $'(if $pane.title == 'hx' { ':o' } else { 'hx' }) ($file)(char cr)'
      wezterm cli activate-pane-direction right
    } catch {
      let pane_id = wezterm cli split-pane --right --cells 117 hx | into int
      # FIXME: (char cr) at the end does not work
      wezterm cli send-text --no-paste --pane-id $pane_id $':o ($file)'
    }
    wezterm cli activate-pane-direction right
}
