{
  imports = [
    (
      {pkgs, ...}: {
        programs.bash.enable = true;

        services.gpg-agent.enable = true;
        services.gpg-agent.enableSshSupport = true;
        services.gpg-agent.defaultCacheTtl = 60;
        services.gpg-agent.maxCacheTtl = 120;
        services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
      }
    )
  ];
}
