{ self, ... }: {
  flake.nixosModules.common-server = { pkgs, ... }: {
    imports = [
      self.nixosModules.common
    ];

    age.identityPaths = [ "/root/.ssh/id_ed25519" ];

    users.users.root.initialPassword = "root";

    environment.systemPackages = with pkgs; [
      git
      wget
      neovim
      btop
      zlib-ng
      cryptsetup
      docker-compose
      wireguard-tools
      borgbackup
    ];

    services.openssh.enable = true;
  };
}
