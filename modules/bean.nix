{ self, ... }: {
  systems = [
    "x86_64-linux"
  ];
  perSystem = { config, inputs', ... }: {
    _module.args.pkgs = inputs'.nixpkgs-unstable.legacyPackages;
    packages.bean = config._module.args.pkgs.writers.writePython3Bin "bean" {
      libraries = with config._module.args.pkgs.python313Packages; [
        beanquery
        mergedeep
      ];
    } ../files/bean.py;
  };
  flake.nixosModules.bean = { pkgs, ... }: {
    home-manager.users.sergio = {
      home.packages = [
        pkgs.beancount
        pkgs.beanquery
        pkgs.fava
        self.packages."x86_64-linux".bean
      ];
      programs.neovim.plugins = [
        pkgs.vimPlugins.vim-beancount
      ];
    };
  };
}
