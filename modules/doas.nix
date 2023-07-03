{ ... }: {
  flake.nixosModules.doas = { pkgs, ... }: {
    security = {
      sudo.enable = false;
      doas.enable = true;
    };
    environment.systemPackages = [
      pkgs.doas-sudo-shim
    ];
  };
}
