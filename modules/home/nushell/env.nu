$env.GPG_TTY = (tty)

if (sys host | get name) == 'Darwin' {
  use std "path add"
  path add /opt/homebrew/bin
}
