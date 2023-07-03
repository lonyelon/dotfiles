{ self, inputs, ... }: {
  flake = {
    nixosConfigurations.nixpad = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.common-pc
        self.nixosModules.nixpad
      ];
    };
    nixosModules.nixpad = { config, lib, ... }: {
      networking.hostName = "nixpad";
      wayland = {
        hyprlandMonitorList = [ "LVDS-1, 1366x768@60, 0x0, 1.0" ];
        isLaptop = true;
        reducePowerUsage = true;
      };

      boot = {
        initrd = {
          availableKernelModules = [
            "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci"
          ];
          luks.devices."luks-02980379-1210-4655-abda-709a9e8e48a1".device = 
            "/dev/disk/by-uuid/02980379-1210-4655-abda-709a9e8e48a1";
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/7a0a786f-d79d-4b54-b886-75b1ad046478";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/B0C7-42F5";
          fsType = "vfat";
        };
      };

      networking.useDHCP = true;

      hardware.cpu.intel.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
