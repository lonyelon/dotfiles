{ self, inputs, ... }: {
  flake.nixosConfigurations.rpi = inputs.nixos-raspberrypi.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
      inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.page-size-16k
      inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
      self.nixosModules.common-server
      self.nixosModules.rpi
    ];
    specialArgs = inputs;
  };
  flake.nixosModules.rpi = {
    time.timeZone = "Europe/Madrid";

    networking.hostName = "rpi";

    fileSystems = {
      "/boot/firmware" = {
        device = "/dev/disk/by-label/FIRMWARE";
        fsType = "vfat";
        options = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=1min"
        ];
      };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };

    hardware.bluetooth.enable = true;

    system.stateVersion = "24.11";
  };
}
