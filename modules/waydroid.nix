{ ... }: {
  flake = {
    nixosModules.waydroid = { ... }: {
      virtualisation.waydroid.enable = true;
      networking.nftables.enable = true;
    };
  };
}
