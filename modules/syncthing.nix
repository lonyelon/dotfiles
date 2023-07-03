{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    home-manager.users.sergio.services.syncthing = {
      enable = true;
      tray.enable = true;
    };
  };
}
