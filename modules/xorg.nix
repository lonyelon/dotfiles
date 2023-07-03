{ inputs, pkgs, ... }: {

  # Fallback module just in case I need Xorg for anything that Wayland still does
  # not support.
  flake.nixosModules.xorg = { lib, pkgs, ... }: {
    nixpkgs.overlays = [(final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = final.fetchFromGitHub {
        owner = "lonyelon";
        repo = "dwm";
        rev = "462d7610c2742e21f106018994343db5471f3db9";
        sha256 = "sha256-bSRHcVrjAvflqV8CqpKh1rU5i4HdeowsNCTsGTYfp0M=";
      };});
      dmenu = prev.dmenu.overrideAttrs (old: { src = final.fetchFromGitHub {
        owner = "lonyelon";
        repo = "dmenu";
        rev = "v1.0";
        sha256 = "sha256-Q8h6qMenzojgjbFYZJs+fYmm1Brcql78OtwOH4HV88E=";
      };});
      st = prev.st.overrideAttrs (old: { src = final.fetchFromGitHub {
        owner = "lonyelon";
        repo = "st";
        rev = "b4faca1ba5423214e6dc647728b62644d8622b9e";
        sha256 = "sha256-JInoG3CL/kXhgCnM5qG8JbPlLmQgtuyLCQZPy0uX7XY=";
      };});
    })];

    environment.systemPackages = with pkgs; [
      st
      dmenu
    ];

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
      windowManager.dwm.enable = true;
    };

    home-manager.users.sergio = {
      home = {
        file.".xinitrc".text = let
            wallpaper = builtins.fetchurl {
              url = "https://github.com/lunik1/nixos-logo-gruvbox-wallpaper/blob/master/png/gruvbox-dark-rainbow.png?raw=true";
              sha256 = "sha256:036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
            };
          in ''
            feh --bg-fill ${wallpaper}
            xrandr --rate 144
            exec dwm
          '';
        packages = with pkgs; [
          redshift
        ];
      };
      services.redshift = {
        enable = true;
        provider = "manual";
        latitude = 42.533331;
        longitude = -8.7666639;
        temperature.night = 3500;
        settings = {
          redshift = {
            adjustment-method = "randr";
            brightness-night = 0.5;
          };
        };
      };
    };
  };
}
