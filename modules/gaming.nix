{ lib, pkgs, ... }: {
  flake.nixosModules.gaming = { lib, pkgs, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

    programs.steam.enable = true;

    home-manager.users.sergio.home.packages = [
      pkgs.pcsx2
    ];
  };
}
