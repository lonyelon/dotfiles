{ self, inputs, ... }: {
  flake = {
    nixOnDroidConfigurations.pixel8a = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs-unstable {
        system = "aarch64-linux";
      };
      modules = [
        self.nixOnDroidModules.pixel8a
      ];
    };
    nixOnDroidModules.pixel8a = { pkgs, ... }: {
      time.timeZone = "Europe/Madrid";
      environment.packages = with pkgs; [
        curl         # Web browsers.
          wget       #  .
        gcc          # Development.
          cargo      #  .
          git        #  .
          gnumake    #  .
          cmake      #  .
          platformio #  .
        jq           # Parsers.
          yq         #  .
        neovim       # Coolest text editor.
          rsync      #  .
      ];
      system.stateVersion = "24.05";
    };
  };
}
