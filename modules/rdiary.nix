{ inputs, pkgs, ... }: {
  flake.nixosModules.rdiary = { pkgs, ... }: {
    home-manager.users.sergio.home.packages = [
      inputs.rdiary.packages."x86_64-linux".default
    ];
  };
}
