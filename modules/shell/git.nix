{
  flake.modules.homeManager.git = {pkgs, ...}: {
    programs.difftastic = {
      enable = true;
      git.enable = true;
      git.diffToolMode = true;
      options.display = "inline";
    };

    programs.git.enable = true;
    programs.git.settings = {
      credential.helper =
        if pkgs.stdenv.isDarwin
        then "osxkeychain"
        else "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret";
      user.name = "Dan Bluhm Hansen";
      user.email = "00.pavers_dither@icloud.com";
      user.signingKey = "~/.ssh/id_rsa.pub";
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.gpgSign = true;
      commit.verbose = true;
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      gpg.format = "ssh";
      init.defaultBranch = "dev";
      merge.conflictStyle = "zdiff3";
      push.autoSetupRemote = true;
      tag.gpgSign = true;
      tag.sort = "-version:refname";
      alias = rec {
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
        di = "diff -- . ':(exclude)*.lock'";
        ds = "diff --cached";
        dsi = "diff --cached -- . ':(exclude)*.lock'";
        du = "diff @{upstream}";
        f = "fetch";
        fa = "fetch --all --prune";
        fo = "fetch origin";
        l = "log --ext-diff";
        lp = "log --ext-diff --stat --patch";
        lg = "log --ext-diff --graph";
        lo = "log --ext-diff --oneline";
        log = "log --ext-diff --oneline --graph";
        lod = "log --ext-diff --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
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
  };
}
