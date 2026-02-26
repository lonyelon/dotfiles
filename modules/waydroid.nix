{ ... }: {
  flake = {
    nixosModules.icebear = { ... }: {
      virtualisation.waydroid.enable = true;
      networking.nftables.enable = true;
    };
  };
}
