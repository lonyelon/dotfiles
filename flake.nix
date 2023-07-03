{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    rdiary = {
      url = "github:lonyelon/rdiary/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    ktl = {
      url = "github:lonyelon/ktl/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    autofirma-nix = {
      # FIXME: Not working in main because something is broken there:
      #        https://github.com/nix-community/autofirma-nix/commits/main/
      url = "github:nix-community/autofirma-nix/75770f68709e764659712ff152193d7986db2530";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix.url = "github:ryantm/agenix";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";

      # TODO: Pending merge when https://github.com/NixOS/nixpkgs/pull/398456
      #       gets into nixpkgs.
      #inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  }; 

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./modules);
}
