{ inputs, ... }: {
  flake.nixosModules.stevenblack-hosts = { ... }: {
    imports = [
      inputs.hosts.nixosModule
    ];
    networking.stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
    };
  };
}
