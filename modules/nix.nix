{ self, inputs, ... }: {
  flake = {
    nixosModules.nix = { pkgs, ... }: {
      nix = {
        package = pkgs.lix;
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          trusted-users = [ "root" ];
        };
      };
    };
  };
}
