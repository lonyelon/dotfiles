{ inputs, pkgs, ... }: {
  flake.nixosModules.ktl = { pkgs, ... }: {
    home-manager.users.sergio.home.packages = [
      inputs.ktl.packages."x86_64-linux".ktl-query
    ];
  };
}
