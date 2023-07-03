{ inputs, lib, pkgs, ... }: {
  flake.nixosModules.emacs = { config, lib, pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
    ];
    home-manager.users.sergio = {
      imports = [
        inputs.nix-doom-emacs-unstraightened.homeModule
      ];
      accounts.email.accounts = lib.mapAttrs (name: _: {
          mu.enable = true;
        }) config.lib.mail.accounts;
      home = {
        file.".local/share/emacs.png".source = ../files/emacs.png;
        packages = with pkgs; [
          ispell
          jre_minimal # Required for ispell
          texlive.combined.scheme-full
          fd
          rust-analyzer # Required for (rust +lsp)
          clang-tools # Required for (cc +lsp)
          ty # Required for (python +lsp)
        ];
      };
      programs = {
        mu.enable = true;
        doom-emacs = {
          enable = true;
          doomDir = ../files/doom;
          tangleArgs = "--all config.org";
        };
      };
      services.emacs.enable = true;
    };
  };
}
