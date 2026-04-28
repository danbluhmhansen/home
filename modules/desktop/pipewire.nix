{inputs, ...}: {
  flake.modules.nixos.pipewire = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.pipewire];
    security.rtkit.enable = true;
    services = {
      pipewire.enable = true;
      pipewire.alsa.enable = true;
      pipewire.pulse.enable = true;
    };
  };

  flake.modules.homeManager.pipewire = {services.easyeffects.enable = true;};
}
