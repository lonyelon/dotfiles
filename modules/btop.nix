{ ... }: {
  flake.nixosModules.btop = { ... }: {
    home-manager.users.sergio.home.file.".config/btop/btop.conf".source = ../files/btop.conf;
  };
}
