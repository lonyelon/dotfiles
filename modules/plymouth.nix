{ inputs, ... }: {
  flake.nixosModules.plymouth = { pkgs, ... }: {
    boot.plymouth = {
        enable = true;
        theme = "mac-style";
        themePackages = [ inputs.mac-style-plymouth-theme.packages.${pkgs.system}.default ];
    };
  };
}
