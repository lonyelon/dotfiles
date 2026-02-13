{ self, inputs, ... }: {
  flake.nixosModules.common-pc = { lib, modulesPath, pkgs, ... }: {
    environment.systemPackages = [
        pkgs.pavucontrol
    ];
    security.rtkit.enable = true;
    services = {
      pulseaudio.enable = false;
      pipewire = {
        alsa = {
          enable = true;
          support32Bit = true;
        };
        enable = true;
        pulse.enable = true;
      };
    };
  };
}
