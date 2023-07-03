{ ... }: {
  flake.nixosModules.env = { config, ... }: {
    home-manager.users.sergio.home.sessionVariables = {
      BROWSER = "librewolf";
      TERMINAL = "st";
      EDITOR = "nvim";

      # TODO: Move to XDG directories.
      PASSWORD_STORE_DIR = "${config.home-manager.users.sergio.home.homeDirectory}/.local/share/passwords";
      INPUTRC ="${config.home-manager.users.sergio.home.homeDirectory}/.config/readline/inputrc";
      GNUPGHOME ="${config.home-manager.users.sergio.home.homeDirectory}/.local/share/gnupg";
      LESSKEY = "${config.home-manager.users.sergio.home.homeDirectory}/.config/less/lesskey";
      LESSHISTFILE = "${config.home-manager.users.sergio.home.homeDirectory}/.config/less/history";

      RDIARY_DIARY_DIR = "${config.home-manager.users.sergio.home.homeDirectory}/doc/org/roam/daily";

      PATH = "$PATH:$XDG_BIN_HOME";
    };
  };
}
