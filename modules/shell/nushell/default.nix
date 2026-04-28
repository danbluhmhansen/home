{inputs, ...}: let
  common = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.nushell];
    programs.bash.interactiveShellInit = ''
      if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
        exec nu
      fi
    '';
    programs.zsh.interactiveShellInit = ''
      if ! [[ "$TERM" = "dumb" ]] && [[ -z "$ZSH_EXECUTION_STRING" ]]; then
        exec nu
      fi
    '';
  };
in {
  flake.modules.nixos.nushell = {pkgs, ...}: common // {environment.shells = [pkgs.nushell];};
  flake.modules.darwin.nushell = {pkgs, ...}: common // {environment.shells = [pkgs.nushell];};
  flake.modules.homeManager.nushell = {
    programs.carapace.enable = true;
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
    };
    programs.vivid = {
      enable = true;
      activeTheme = "ansi";
    };
  };
}
