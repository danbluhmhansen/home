{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    theme = {
      status = {
        mode_normal = {
          bg = "black";
          fg = "blue";
          bold = true;
        };
        mode_select = {
          bg = "black";
          fg = "red";
          bold = true;
        };
        mode_unset = {
          bg = "black";
          fg = "red";
          bold = true;
        };
      };
    };
  };
}
