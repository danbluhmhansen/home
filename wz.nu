def main [file: string, directory: string] {
  try {
    let pane_id = wezterm cli get-pane-direction right | into int
    let title = wezterm cli list --format json | from json | where pane_id == $pane_id | first | get title
    wezterm cli send-text --no-paste --pane-id $pane_id $'(if $title == 'hx' { ':o' } else { 'hx' }) ($file)(char cr)'
    wezterm cli activate-pane-direction right
  } catch {
    let pane_id = wezterm cli split-pane --cwd $directory --right --cells 117 -- /bin/zsh -c 'nu' | into int
    # FIXME: (char cr) at the end does not work
    wezterm cli send-text --no-paste --pane-id $pane_id $'hx ($file)(char cr)'
    wezterm cli activate-pane-direction right
  }
}
