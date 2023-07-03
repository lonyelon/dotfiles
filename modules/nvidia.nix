{ inputs, ... }: {
  flake.nixosModules.nvidia-gpu = { config, lib, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics.enable = true;
      nvidia-container-toolkit.enable = true;
      nvidia = {
        open = true;

        # FIXME This is only required while https://github.com/NixOS/nixpkgs/issues/467814.
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };
  };
}
