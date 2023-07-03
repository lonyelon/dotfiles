{ self, inputs, lib, ... }: {
  flake.nixosConfigurations.nixremberg = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.simple-nixos-mailserver.nixosModule
      self.nixosModules.vpn-server
      self.nixosModules.common-server
      self.nixosModules.nixremberg
    ];
  };
  flake.nixosModules.nixremberg = { config, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    networking = {
      hostName = "nixremberg";
      useDHCP = lib.mkDefault false;
      defaultGateway = "172.31.1.1";
      defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };
      nat = {
        enable = true;
        externalInterface = "ens3";
        internalInterfaces = [ "wg0" ];
      };
      usePredictableInterfaceNames = lib.mkForce false;
      interfaces = {
        eth0 = {
          ipv4 = {
            addresses = [{
              address="195.201.231.120";
              prefixLength=32;
            }];
            routes = [{
              address = "172.31.1.1";
              prefixLength = 32;
            }];
          };
          ipv6 = {
            addresses = [
              { address="2a01:4f8:1c1e:4d9c::1"; prefixLength=64; }
              { address="fe80::9400:4ff:fe15:94a2"; prefixLength=64; }
            ];
            routes = [
              { address = "fe80::1"; prefixLength = 128; }
            ];
          };
        };
      };
    };

    boot = {
      tmp.cleanOnBoot = true;
      kernelModules = [ "kvm-intel" ];
      loader.grub.device = "/dev/sda";
      initrd = {
        kernelModules = [ "nvme" ];
        availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
      };
    };

    fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

    zramSwap.enable = true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    system.stateVersion = "24.05";
  };
}
