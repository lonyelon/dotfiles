{ self, inputs, ... }: {
  flake = {
    nixOnDroidConfigurations.pixel8a = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs-unstable {
        system = "aarch64-linux";
      };
      modules = [
        self.nixosModules.pixel8a
      ];
    };
    nixosModules.pixel8a = { ... }: {
      time.timeZone = "Europe/Madrid";
      system.stateVersion = "25.11";
    };
  };
}
