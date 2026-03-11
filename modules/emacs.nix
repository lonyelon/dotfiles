{ inputs, lib, pkgs, ... }: {
  flake.nixosModules.emacs = { config, lib, pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      inter
    ];
    home-manager.users.sergio = {
      imports = [
        inputs.nix-doom-emacs-unstraightened.homeModule
      ];
      accounts.email.accounts = lib.mapAttrs (name: _: {
          mu.enable = true;
        }) config.lib.mail.accounts;
      home = {
        file.".local/share/emacs.png".source = let
            emacsCover = pkgs.fetchurl {
              url = "https://upload.wikimedia.org/wikipedia/commons/4/49/%22The_School_of_Athens%22_by_Raffaello_Sanzio_da_Urbino.jpg";
              sha256 = "sha256-o1GwucQp2D5x6ZLffTpDN3XDfhisRu9vZjUgsHWxfvQ=";
            };
          in pkgs.runCommand "process_cover" {
                nativeBuildInputs = [ pkgs.imagemagick ];
              } ''
                magick ${emacsCover} -crop 435x550+1750+1250 -resize 290x366 $out
              '';
        packages = with pkgs; [
          texlive.combined.scheme-full
          lean4
        ];
      };
      programs = {
        mu.enable = true;
        doom-emacs = {
          enable = true;
          doomDir = ../files/doom;
          tangleArgs = "--all config.org";
          extraBinPackages = with pkgs; [
            ispell
            jre_minimal # Required for ispell
            rust-analyzer # Required for (rust +lsp)
            clang-tools # Required for (cc +lsp)
            ty # Required for (python +lsp)
            git
            ripgrep
            fd
            sqlite
          ];
        };
      };
      services.emacs.enable = true;
    };
  };
}
