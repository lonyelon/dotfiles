{ self, inputs, lib, pkgs, ... }: {
  flake = {
    nixosConfigurations.nixtab = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.common-pc
        self.nixosModules.nixtab
      ];
    };
    nixosModules.nixtab = { config, pkgs, lib, ... }: {
      networking.hostName = "nixtab";
      wayland = {
        hyprlandMonitorList = [ "eDP-1, 1920x1280@60, 0x0, 1.6" ];
        hasTouchScreen = true;
        isLaptop = true;
      };

      boot = {
        initrd = {
          availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/9b85d698-6e61-400d-a052-58b3b137fb28";
          fsType = "ext4";
        };
        "/boot" = { device = "/dev/disk/by-uuid/31D8-F4C5";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };
      };

      swapDevices = [ ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware = {
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        sensor.iio.enable = true;
      };
    };
  };
}
