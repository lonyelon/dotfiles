{ ... }: {
  perSystem = { inputs', ... }: {
    _module.args.pkgs = inputs'.nixpkgs.legacyPackages;
  };
}
