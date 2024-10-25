{
  imports = [
    ({flake, ...}: {
      home.sessionVariables = {
        PASSWORD_STORE_DIR = "/home/${flake.config.me.username}/.local/share/pass";
      };
      programs.bash.enable = true;
    })
  ];
}
