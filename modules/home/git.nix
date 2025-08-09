{
  userName,
  email,
  ...
}: {
  programs.git = {
    userName = userName;
    userEmail = email;
    delta.enable = true;
    delta.options.hyperlinks = true;
    signing.key = "0x077BBC8A99A747DD";
    signing.signByDefault = true;
    extraConfig = {
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      init.defaultBranch = "dev";
      merge.conflictStyle = "zdiff3";
      push.autoSetupRemote = true;
      tag.sort = "-version:refname";
    };

    aliases = rec {
      a = "add";
      aa = "add --all";
      ap = "add --patch";
      b = "branch";
      ba = "branch --all";
      bd = "branch --delete";
      bd- = "branch --delete --force";
      c = "commit";
      c- = "commit --amend";
      ca = "commit --all";
      ca- = "commit --all --amend";
      cb = "checkout -b";
      cb- = "checkout -B";
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
      lodd = "${lod} --date=short";
      lods = "${lod} --stat";
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
