{ self, inputs, ... }: {
  flake.nixosModules.git = { config, pkgs, ... }: {
    home-manager.users.sergio.programs.git = {
      enable = true;
      settings = {
        tag.sort = "version:refname";
        init.defaultBranch = "main";
        help.autocorrect = "prompt";
        commit.verbose = true;
        user = {
          name = "Sergio Miguéns Iglesias";
          email = "sergio@lony.xyz";
        };
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = "true";
          renames = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };
    };
  };
}
