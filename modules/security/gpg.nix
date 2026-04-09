{
  flake.modules.darwin.gpg = {
    programs.gnupg.agent.enable = true;
    programs.gnupg.agent.enableSSHSupport = true;
  };
  flake.modules.homeManager.gpg = {pkgs, ...}: {
    home.packages = with pkgs; [openssh libfido2];
    programs.gpg = {
      enable = true;
      scdaemonSettings.disable-ccid = true;
      publicKeys = [
        {
          source = pkgs.fetchurl {
            url = "https://keys.openpgp.org/vks/v1/by-fingerprint/F5DC22A680631D2C9E04867F077BBC8A99A747DD";
            sha256 = "CLepFmgsa1Hy4fZo7Z57dGF7DwCGcuYMyOivr6cKwqM=";
          };
          trust = 5;
        }
      ];
      settings = {
        personal-cipher-preferences = ["AES256" "AES192" "AES"];
        personal-digest-preferences = ["SHA512" "SHA384" "SHA256"];
        personal-compress-preferences = ["ZLIB" "BZIP2" "ZIP" "Uncompressed"];
        default-preference-list = [
          "SHA512"
          "SHA384"
          "SHA256"
          "AES256"
          "AES192"
          "AES"
          "ZLIB"
          "BZIP2"
          "ZIP"
          "Uncompressed"
        ];
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
        keyserver = "hkps://keys.openpgp.org";
      };
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
    };
  };
  flake.modules.homeManager.mercury = {pkgs, ...}: {services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;};
  flake.modules.homeManager.mars = {pkgs, ...}: {services.gpg-agent.pinentry.package = pkgs.pinentry-curses;};
  flake.modules.homeManager.jupiter = {pkgs, ...}: {services.gpg-agent.pinentry.package = pkgs.pinentry_mac;};
  flake.modules.homeManager.saturn = {pkgs, ...}: {services.gpg-agent.pinentry.package = pkgs.pinentry-curses;};
}
