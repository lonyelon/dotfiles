{ self, ... }: {
  flake.nixosModules.common = {
    imports = [
      self.nixosModules.locale
      self.nixosModules.openssh
      self.nixosModules.doas
      self.nixosModules.nix
      self.nixosModules.agenix
      self.nixosModules.private-vpn-client
    ];
  };
}
