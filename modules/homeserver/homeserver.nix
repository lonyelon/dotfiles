{ self, config, inputs, lib, pkgs, ... }: {
  flake = {
    nixosConfigurations.homeserver = inputs.nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.common-server
        self.nixosModules.homeserver
        self.nixosModules.public-vpn-client
      ];
    };
    nixosModules.homeserver = { config, pkgs, lib, modulesPath, ... }: {
      imports = [(modulesPath + "/installer/scan/not-detected.nix")];

      time.timeZone = "Europe/Madrid";

      services = {
        prometheus = {
          enable = true;
          scrapeConfigs = [{
            job_name = "node";
            static_configs = [{
              targets = [ "localhost:9100" ];
            }];
          }];
          exporters.node = {
            enable = true;
            enabledCollectors = [ "filesystem" "diskstats" ];
          };
        };
        borgbackup = {
          jobs.data = {
            paths = "/opt/data";
            user = "root";
            startAt = "*-*-* 08:30:00";
            repo = "/opt/backup/borg/homeserver-data";
            encryption.mode = "none";
            prune.keep = {
              within = "1d";
              daily = 10;
              monthly = 3;
              yearly = 1;
            };
            readWritePaths = [ "/opt/data" "/opt/backup/borg" ];
            preHook = ''
              df -h | grep -q /opt/backup || exit 2
            '';
          };
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/bb07a995-c7a2-4cb6-ab98-ce2cf59fe3f3";
          fsType = "btrfs";
        };
        "/nix" = {
          device = "/dev/disk/by-uuid/91b0a7d6-d85e-439f-ae3c-f15d6dc3a233";
          fsType = "btrfs";
        };
        "/home" = {
          device = "/dev/disk/by-uuid/cc14cd03-f749-4600-b032-cde7fc8a56d3";
          fsType = "btrfs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/3B39-E1D5";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };
        "/pass" = {
          device = "/dev/disk/by-uuid/62ED-8D3C";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };
      };

      zramSwap.enable = true;

      networking = {
        useDHCP = lib.mkDefault true;
        hostName = "homeserver";
        firewall.enable = false;
        interfaces.enp3s0.wakeOnLan.enable = true;
      };

      boot = {
        swraid.enable = true;
        kernelModules = [ "kvm-intel" ];
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ehci_pci"
            "ahci"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [ "dm-snapshot" ];
        };
      };

      system.stateVersion = "24.11";
    };
  };
}
