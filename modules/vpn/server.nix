{ config, lib, self, ... }: {
  flake.nixosModules.vpn-server = { config, ...}: {
    imports = [
      self.nixosModules.common-vpn
    ];
    age.secrets = {
      "${config.lib.vpn.private.name}.pri".file =
        ../../secrets/${config.lib.vpn.private.name}.pri.age;

      "${config.lib.vpn.private.name}.icebear.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.icebear.pre.age;
      "${config.lib.vpn.private.name}.pixel8a.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.pixel8a.pre.age;
      "${config.lib.vpn.private.name}.homeserver.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.homeserver.pre.age;
      "${config.lib.vpn.private.name}.nixremberg.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.nixremberg.pre.age;
      "${config.lib.vpn.private.name}.rpi.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.rpi.pre.age;
      "${config.lib.vpn.private.name}.nixtab.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.nixtab.pre.age;
      "${config.lib.vpn.private.name}.nixpad.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.nixpad.pre.age;
      "${config.lib.vpn.private.name}.archremote.pre".file =
        ../../secrets/${config.lib.vpn.private.name}.archremote.pre.age;

      "${config.lib.vpn.public.name}.pri".file =
        ../../secrets/${config.lib.vpn.public.name}.pri.age;

      "${config.lib.vpn.public.name}.homeserver.pre".file =
        ../../secrets/${config.lib.vpn.public.name}.homeserver.pre.age;
      "${config.lib.vpn.public.name}.emma-iphone.pre".file =
        ../../secrets/${config.lib.vpn.public.name}.emma-iphone.pre.age;
      "${config.lib.vpn.public.name}.emma-pc.pre".file =
        ../../secrets/${config.lib.vpn.public.name}.emma-pc.pre.age;
      "${config.lib.vpn.public.name}.emma-ipad.pre".file =
        ../../secrets/${config.lib.vpn.public.name}.emma-ipad.pre.age;
    };
    networking = {
      firewall.allowedUDPPorts = [
        config.lib.vpn.private.port
        config.lib.vpn.public.port
      ];
      wg-quick.interfaces = lib.mkForce {};
      wireguard = {
        enable = true;
        interfaces = {
          private-wg = {
            listenPort = config.lib.vpn.private.port;
            privateKeyFile = "${config.age.secrets."${config.lib.vpn.private.name}.pri".path}";
            ips = [ config.lib.vpn.private.network ];
            peers = lib.mapAttrsToList (name: value: {
                publicKey = value.publicKey;
                presharedKeyFile = "${config.age.secrets."${config.lib.vpn.private.name}.${name}.pre".path}";
                allowedIPs = [ "${value.ip}/32" ];
              }) config.lib.vpn.private.peers;
          };
          public-wg = {
            listenPort = config.lib.vpn.public.port;
            privateKeyFile = "${config.age.secrets."${config.lib.vpn.public.name}.pri".path}";
            ips = [ config.lib.vpn.public.network ];
            peers = lib.mapAttrsToList (name: value: {
                publicKey = value.publicKey;
                presharedKeyFile = "${config.age.secrets."${config.lib.vpn.public.name}.${name}.pre".path}";
                allowedIPs = [ "${value.ip}/32" ];
              }) config.lib.vpn.public.peers;
          };
        };
      };
    };
  };
}
