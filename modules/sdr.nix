{ self, inputs, ... }: {
  flake.nixosModules.common-pc = { lib, modulesPath, pkgs, ... }: {
    environment.systemPackages = [
      pkgs.sdrpp
    ];
    hardware = {
      rtl-sdr.enable = true;
      hackrf.enable = true;
    };
  };
}
