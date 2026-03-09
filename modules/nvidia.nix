{ inputs, ... }: {
  flake.nixosModules.nvidia-gpu = { config, lib, pkgs, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics.enable = true;
      opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = [
          pkgs.nvidia-vaapi-driver
        ];
      };
      nvidia-container-toolkit.enable = true;
      nvidia = {
        open = true;
        modesetting.enable = true;
        powerManagement.enable = true;

        # FIXME This is only required while https://github.com/NixOS/nixpkgs/issues/467814.
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };
  };
}
