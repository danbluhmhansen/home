{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    settings = {
      git_branch.format = "[$symbol$branch(:$remote_branch)]($style)";
      git_branch.style = "";
      git_branch.symbol = " ";
      git_status.format = "([$all_status$ahead_behind]($style))";
      git_status.style = "";
    };
  };
}
