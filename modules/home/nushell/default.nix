{pkgs, ...}: {
  programs.carapace.enable = true;
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    extraConfig = ''
      use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/sourced/cool-oneliners/dict.nu
    '';
  };
}
