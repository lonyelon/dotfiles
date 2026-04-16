{ config, lib, self, ... }: {
  flake.nixosModules.public-vpn-client = { config, ... }: {
    imports = [
      self.nixosModules.common-vpn
    ];
    networking.wg-quick.interfaces.${config.lib.vpn.public.name} = let
        homeDir = if builtins.hasAttr "sergio" config.users.users then
            config.users.users.sergio.home
          else
            config.users.users.root.home;
      in {
        privateKeyFile = "${homeDir}/.config/wg/pri.key";
        address = [ config.lib.vpn.public.peers.${config.networking.hostName}.ip ];
        dns = config.lib.vpn.public.dns;
        peers = [{
          publicKey = config.lib.vpn.public.publicKey;
          presharedKeyFile = "${homeDir}/.config/wg/pre.key";
          allowedIPs = [ config.lib.vpn.public.network ];
          endpoint = "${config.lib.vpn.public.host}:${builtins.toString config.lib.vpn.public.port}";
          persistentKeepalive = 25;
        }];
      };
  };
}
