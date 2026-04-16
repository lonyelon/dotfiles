{ config, lib, self, ... }: {
  flake.nixosModules.private-vpn-client = { config, ... }: {
    imports = [
      self.nixosModules.common-vpn
    ];
    age.secrets = {
      "${config.lib.vpn.private.name}.${config.networking.hostName}.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.${config.networking.hostName}.pre.age;
      "${config.lib.vpn.private.name}.${config.networking.hostName}.pri".file =
        ../../secrets/${config.lib.vpn.private.name}.${config.networking.hostName}.pri.age;
    };
    networking.wg-quick.interfaces.${config.lib.vpn.private.name} = let
        homeDir = if builtins.hasAttr "sergio" config.users.users then
            config.users.users.sergio.home
          else
            config.users.users.root.home;
      in {
        privateKeyFile = "${config.age.secrets."${config.lib.vpn.private.name}.${config.networking.hostName}.pri".path}";
        address = [ config.lib.vpn.private.peers.${config.networking.hostName}.ip ];
        dns = config.lib.vpn.private.dns;
        peers = [{
          publicKey = config.lib.vpn.private.publicKey;
          presharedKeyFile = "${config.age.secrets."${config.lib.vpn.private.name}.${config.networking.hostName}.pre".path}";
          allowedIPs = [ config.lib.vpn.private.network ];
          endpoint = "${config.lib.vpn.private.host}:${builtins.toString config.lib.vpn.private.port}";
          persistentKeepalive = 25;
        }];
      };
  };
}
