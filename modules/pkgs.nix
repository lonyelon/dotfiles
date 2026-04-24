{ ... }: {
  perSystem = { inputs', ... }: {
    _module.args.pkgs = inputs'.nixpkgs-unstable.legacyPackages;
  };
}
