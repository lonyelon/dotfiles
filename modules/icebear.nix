{ self, inputs, lib, pkgs, ... }: {
  flake = {
    nixosConfigurations.icebear = inputs.nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.icebear
        self.nixosModules.common-pc
        self.nixosModules.gaming
        self.nixosModules.nvidia-gpu
      ];
    };
    nixosModules.icebear = { config, pkgs, lib, ... }: {
      wayland.hyprlandMonitorList = [ "DP-1, 2560x1440@144, 0x0, 1.0" ];

      virtualisation = {
        libvirtd.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
      security.polkit.enable = true; # Required for virt-manager.

      services = {
        pcscd.enable = true;
        openssh.enable = true;
        i2pd = {
          enable = true;
          proto = {
            http.enable = true; # Web interface
            httpProxy.enable = true;
            socksProxy.enable = true;
          };
        };
        borgbackup.jobs.main = {
          paths = "/home/sergio";
          user = "sergio";
          startAt = "*-*-* 00:00:00";
          repo = "ssh://root@192.168.1.200/opt/backup/borg/icebear";
          encryption.mode = "none";
          prune.keep = {
            within = "1d";
            daily = 7;
            weekly = 4;
            monthly = 3;
          };
          preHook = ''
            ${pkgs.iputils}/bin/ping -c 1 192.168.1.200 || exit 1
            ${pkgs.openssh}/bin/ssh root@192.168.1.200 'df -h' | grep -q /opt/backup || exit 2
          '';
          patterns = [
            "! **/.pio"
            "! **/.git"
            "! /home/sergio/.config/chromium/BrowserMetrics/**"
            "! /home/sergio/.local/share/containers/**"
            "+ /home/sergio/.config/wg"
            "+ /home/sergio/.config/mail"
            "- /home/sergio/.config/**"
            "+ /home/sergio/.local/share/mail"
            "+ /home/sergio/.local/share/monero"
            "- /home/sergio/.local/**"
            "- /home/sergio/.*"
            "- /home/sergio/dw"
            "- /home/sergio/proj/linux"
            "- /home/sergio/proj/nixpkgs*"
            "- /home/sergio/mnt"
            "- /home/sergio/trash"
          ];
        };
      };

      networking = {
        hostName = "icebear";
        useDHCP = lib.mkDefault true;
        defaultGateway = "192.168.1.1";
      };

      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        kernelModules = [ "kvm-amd" "nvidia" ];
        binfmt.emulatedSystems = [ "aarch64-linux" ];
        initrd = {
          availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
          kernelModules = [ "dm-snapshot" ];
          compressor = "zstd";
          systemd.enable = true;
          luks.devices = {
            root = { 
              device = "/dev/disk/by-uuid/3ecda529-2040-49a4-9a0f-9cd0665d5e36";
              preLVM = true;
              crypttabExtraOpts = [ "password-echo=yes" ];
            };
            home = { 
              device = "/dev/disk/by-uuid/55de6efb-9918-4dc2-9719-13d7159951ff";
              preLVM = true;
              crypttabExtraOpts = [ "password-echo=yes" ];
            };
          };
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/3ae0c024-62f7-4198-adac-e050966c19fb";
          fsType = "btrfs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/8BA8-EF13";
          fsType = "vfat";
        };
        "/home" = {
          device = "/dev/disk/by-uuid/5c7a9f06-0f68-45d1-b8f4-33a74b92f212";
          fsType = "ext4";
        };
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/34cf29c0-3529-4f43-b386-fa79a7608126"; }
      ];

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
