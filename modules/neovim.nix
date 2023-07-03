{ ... }: {
  flake.nixosModules.neovim = { pkgs, ... }: {
    home-manager.users.sergio.programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-gitgutter     # Show diff in lateral panel.
        vim-beancount     # Ledger compatibility.
        vim-sleuth        # Adjust shiftwidth and expandtab based on file type.
        lualine-nvim      # Better status bar.
        telescope-nvim    # Doom-emacs like find.
          plenary-nvim    # telescope-nvim dependency.
        goyo-vim          # Distraction-free writing.
      ];
      initLua = builtins.readFile ../files/neovim/config.lua;
    };
  };
}
