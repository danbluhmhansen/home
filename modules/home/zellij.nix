{
  inputs,
  pkgs,
  ...
}: {
  programs.zellij.extraConfig = ''
    default_layout "dev"
    default_mode "locked"
    load_plugins { compact-bar; }
    pane_frames false
    plugins {
      compact-bar location="zellij:compact-bar" { tooltip "F1"; }
    }
    show_startup_tips false
    theme "ansi"
    keybinds clear-defaults=true {
      locked {
        bind "Ctrl g" { SwitchToMode "normal"; }
      }
      pane {
        bind "h" "Left" { MoveFocus "Left"; }
        bind "l" "Right" { MoveFocus "Right"; }
        bind "j" "Down" { MoveFocus "Down"; }
        bind "k" "Up" { MoveFocus "Up"; }
        bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
        bind "d" { NewPane "down"; SwitchToMode "locked"; }
        bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
        bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
        bind "i" { TogglePanePinned; SwitchToMode "locked"; }
        bind "n" { NewPane; SwitchToMode "locked"; }
        bind "p" { SwitchToMode "normal"; }
        bind "r" { NewPane "right"; SwitchToMode "locked"; }
        bind "s" { NewPane "stacked"; SwitchToMode "locked"; }
        bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
        bind "x" { CloseFocus; SwitchToMode "locked"; }
        bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
        bind "tab" { SwitchFocus; }
      }
      tab {
        bind "h" "Left" "Up" "k" { GoToPreviousTab; }
        bind "l" "Right" "Down" "j" { GoToNextTab; }
        bind "1" { GoToTab 1; SwitchToMode "locked"; }
        bind "2" { GoToTab 2; SwitchToMode "locked"; }
        bind "3" { GoToTab 3; SwitchToMode "locked"; }
        bind "4" { GoToTab 4; SwitchToMode "locked"; }
        bind "5" { GoToTab 5; SwitchToMode "locked"; }
        bind "6" { GoToTab 6; SwitchToMode "locked"; }
        bind "7" { GoToTab 7; SwitchToMode "locked"; }
        bind "8" { GoToTab 8; SwitchToMode "locked"; }
        bind "9" { GoToTab 9; SwitchToMode "locked"; }
        bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
        bind "]" { BreakPaneRight; SwitchToMode "locked"; }
        bind "b" { BreakPane; SwitchToMode "locked"; }
        bind "n" { NewTab; SwitchToMode "locked"; }
        bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
        bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
        bind "t" { SwitchToMode "normal"; }
        bind "x" { CloseTab; SwitchToMode "locked"; }
        bind "tab" { ToggleTab; }
      }
      resize {
        bind "h" "Left" { Resize "Increase Left"; }
        bind "j" "Down" { Resize "Increase Down"; }
        bind "k" "Up" { Resize "Increase Up"; }
        bind "l" "Right" { Resize "Increase Right"; }
        bind "+" { Resize "Increase"; }
        bind "-" { Resize "Decrease"; }
        bind "=" { Resize "Increase"; }
        bind "H" { Resize "Decrease left"; }
        bind "J" { Resize "Decrease down"; }
        bind "K" { Resize "Decrease up"; }
        bind "L" { Resize "Decrease right"; }
        bind "r" { SwitchToMode "normal"; }
      }
      move {
        bind "h" "Left" { MovePane "Left"; }
        bind "j" "Down" { MovePane "Down"; }
        bind "k" "Up" { MovePane "Up"; }
        bind "l" "Right" { MovePane "Right"; }
        bind "m" { SwitchToMode "normal"; }
        bind "n" "Tab" { MovePane; }
        bind "p" { MovePaneBackwards; }
      }
      scroll {
        bind "Alt h" "Alt left" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
        bind "Alt j" "Alt down" { MoveFocus "down"; SwitchToMode "locked"; }
        bind "Alt k" "Alt up" { MoveFocus "up"; SwitchToMode "locked"; }
        bind "Alt l" "Alt right" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
        bind "e" { EditScrollback; SwitchToMode "locked"; }
        bind "f" { SwitchToMode "entersearch"; SearchInput 0; }
        bind "s" { SwitchToMode "normal"; }
      }
      search {
        bind "c" { SearchToggleOption "CaseSensitivity"; }
        bind "n" { Search "down"; }
        bind "o" { SearchToggleOption "WholeWord"; }
        bind "p" { Search "up"; }
        bind "w" { SearchToggleOption "Wrap"; }
      }
      session {
        bind "a" {
          LaunchOrFocusPlugin "zellij:about" {
            floating true
            move_to_focused_tab true
          }
          SwitchToMode "locked"
        }
        bind "c" {
          LaunchOrFocusPlugin "configuration" {
            floating true
            move_to_focused_tab true
          }
          SwitchToMode "locked"
        }
        bind "d" { Detach; }
        bind "o" { SwitchToMode "normal"; }
        bind "p" {
          LaunchOrFocusPlugin "plugin-manager" {
            floating true
            move_to_focused_tab true
          }
          SwitchToMode "locked"
        }
        bind "s" {
          LaunchOrFocusPlugin "zellij:share" {
            floating true
            move_to_focused_tab true
          }
          SwitchToMode "locked"
        }
        bind "w" {
          LaunchOrFocusPlugin "session-manager" {
            floating true
            move_to_focused_tab true
          }
          SwitchToMode "locked"
        }
      }
      shared_among "normal" "locked" {
        bind "Alt h" "Alt left" { MoveFocusOrTab "left"; }
        bind "Alt j" "Alt down" { MoveFocus "down"; }
        bind "Alt k" "Alt up" { MoveFocus "up"; }
        bind "Alt l" "Alt right" { MoveFocusOrTab "right"; }
        bind "Alt +" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt =" { Resize "Increase"; }
        bind "Alt [" { PreviousSwapLayout; }
        bind "Alt ]" { NextSwapLayout; }
        bind "Alt f" { ToggleFloatingPanes; }
        bind "Alt n" { NewPane; }
        bind "Alt p" { TogglePaneInGroup; }
        bind "Alt Shift i" { MoveTab "left"; }
        bind "Alt Shift o" { MoveTab "right"; }
        bind "Alt Shift p" { ToggleGroupMarking; }
      }
      shared_except "locked" "renametab" "renamepane" {
        bind "Ctrl g" { SwitchToMode "locked"; }
        bind "Ctrl q" { Quit; }
      }
      shared_except "locked" "entersearch" {
        bind "enter" { SwitchToMode "locked"; }
      }
      shared_except "locked" "entersearch" "renametab" "renamepane" {
        bind "esc" { SwitchToMode "locked"; }
      }
      shared_except "locked" "entersearch" "renametab" "renamepane" "move" {
        bind "m" { SwitchToMode "move"; }
      }
      shared_except "locked" "entersearch" "search" "renametab" "renamepane" "session" {
        bind "o" { SwitchToMode "session"; }
      }
      shared_except "locked" "tab" "entersearch" "renametab" "renamepane" {
        bind "t" { SwitchToMode "tab"; }
      }
      shared_among "normal" "resize" "tab" "scroll" "prompt" "tmux" {
        bind "p" { SwitchToMode "pane"; }
      }
      shared_among "normal" "resize" "search" "move" "prompt" "tmux" {
        bind "s" { SwitchToMode "scroll"; }
      }
      shared_except "locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane" {
        bind "r" { SwitchToMode "resize"; }
      }
      shared_among "scroll" "search" {
        bind "l" "right" "PageDown" "Ctrl f" { PageScrollDown; }
        bind "h" "left" "PageUp" "Ctrl b" { PageScrollUp; }
        bind "j" "down" { ScrollDown; }
        bind "k" "up" { ScrollUp; }
        bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
      }
      entersearch {
        bind "Ctrl c" "esc" { SwitchToMode "scroll"; }
        bind "enter" { SwitchToMode "search"; }
      }
      renametab {
        bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
      }
      shared_among "renametab" "renamepane" {
        bind "Ctrl c" { SwitchToMode "locked"; }
      }
      renamepane {
        bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
      }
    }
  '';

  xdg.configFile."zellij/layouts/dev.kdl".text = ''
    layout {
      default_tab_template {
        children
        pane size=1 borderless=true {
          plugin location="file:${inputs.zjstatus.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/zjstatus.wasm" {
            format_left   "{mode} {session} {tabs}"
            format_center ""
            format_right  "{command_dir}{command_branch}{command_status}{command_time}"
            format_space  ""

            border_enabled  "false"
            border_char     "─"
            border_format   "#[fg=white]{char}"
            border_position "top"

            hide_frame_for_single_pane "true"

            mode_locked  "#[bg=red] "
            mode_normal  "#[bg=green] "
            mode_pane    "#[bg=blue] "
            mode_tab     "#[bg=yellow] "

            tab_normal   "#[fg=black] {name} "
            tab_active   "#[fg=white] {name} "

            command_dir_command    "starship module directory"
            command_dir_format     "{stdout} "
            command_dir_interval   "1"
            command_dir_rendermode "raw"

            command_branch_command    "starship module git_branch"
            command_branch_format     "{stdout} "
            command_branch_interval   "1"
            command_branch_rendermode "raw"

            command_status_command    "starship module git_status"
            command_status_format     "{stdout} "
            command_status_interval   "1"
            command_status_rendermode "raw"

            command_time_command    "starship module time"
            command_time_format     "{stdout} "
            command_time_interval   "1"
            command_time_rendermode "raw"
          }
        }
      }
    }
  '';
}
