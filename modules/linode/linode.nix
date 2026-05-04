{ self, inputs, lib, ... }: {
  flake.nixosConfigurations.linode = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.common-server
      self.nixosModules.linode
    ];
  };
  flake.nixosModules.linode = { config, modulesPath, ... }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    zramSwap.enable = false;

    networking = {
      hostName = "archremote";
      domain = "(none)";
    };

    services = {
      openssh.enable = true;
      # Workaround for https://github.com/NixOS/nix/issues/8502
      logrotate.checkConfig = false;
    };

    users.users.root.openssh.authorizedKeys.keys = [
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC31rTKk4q7g9DhrJfHItLwTl/etMDwZ7nnQvsttp47I296aQPukeVosGb/ZVi9KqZAGq4/oTUYWNlaglAkL83lKnIEiR2whSoZ+OWvEkGbePWKA1injvvYEh2UI5pvTLS5GcWgVRXo8fwTLo9wHiDnL592tlFygUMrOqYzWXjzL7pBInMTxZ8OvNMxlkJfcoZQb+BRXJw5n0uHWFm7O1PWecuufu2V9YwAXZPsd7A09hYS2oElIf0ENaVL8hWRtQ7qfsaL3oA14wCAeONawruhmK2sQMnxUNEwPDX5YJqMt9yLh6F93JZTW51gmBMoxnC4b9qR+FnSeJ475uNKav1szrGiuZUScoWq4F24ocYb6vYbqVBdl9tcqGqm/hVMge95DtiqjetNJf+G1kfnQucA9LodKRvovXOGxD2gdWbyJLg86hfRNcYCe3yU1FoJ+1d4xR6sO7vsL8ntYvugZJl5bPQEhgXD41yIgc0VzdoD3QBWsFi90KoDwG/w+9UzEik= lonyelon@archlap'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA88vjWBHBQP5iGS0vr4SKhFFhuYKS7lFkTEJZUpy+7u sergio@icebear'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA88vjWBHBQP5iGS0vr4SKhFFhuYKS7lFkTEJZUpy+7u sergio@icebear''
    ];

    boot = {
      tmp.cleanOnBoot = true;
      loader.grub.device = "nodev";
      initrd = {
        availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
        kernelModules = [ "nvme" ];
      };
    };

    fileSystems."/" = {
      device = "/dev/sda"; fsType = "ext4";
    };

    swapDevices = [
      { device = "/dev/sdb"; }
    ];

    system.stateVersion = "23.11";
  };
}
