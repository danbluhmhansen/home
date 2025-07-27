{
  programs.git = {
    userName = "Dan Bluhm Hansen";
    userEmail = "00.pavers_dither@icloud.com";
    delta.enable = true;
    signing.key = "0x077BBC8A99A747DD";
    signing.signByDefault = true;
    extraConfig = {
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      diff.algorithm = "histogram";
      init.defaultBranch = "dev";
      push.autoSetupRemote = true;
      tag.sort = "-version:refname";
    };

    aliases = {
      a = "add";
      aa = "add --all";
      ap = "add --patch";
      b = "branch";
      ba = "branch --all";
      bd = "branch --delete";
      bD = "branch --delete --force";
      c = "commit";
      c- = "commit --amend";
      ca = "commit --all";
      ca- = "commit --all --amend";
      cb = "checkout -b";
      cB = "checkout -B";
      cl = "clone";
      d = "diff";
      ds = "diff --cached";
      du = "diff @{upstream}";
      f = "fetch";
      fa = "fetch --all --prune";
      fo = "fetch origin";
      l = "log";
      lp = "log --stat --patch";
      lg = "log --graph";
      lo = "log --oneline";
      log = "log --oneline --graph";
      lod = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
      lodd = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short";
      lods = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --stat";
      p = "push";
      p- = "push --force";
      pd = "push --dry-run";
      r = "restore";
      s = "status --short --branch";
      u = "pull";
      ur = "pull --rebase";
      ua = "pull --rebase --autostash";
    };
  };
}
