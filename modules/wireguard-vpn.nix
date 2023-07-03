{ config, lib, ... }: let
    vpnData = rec {
      private = {
        host = "195.201.231.120";
        port = 51820;
        network = "10.0.0.1/24";
        dns = [ "8.8.8.8" "8.0.0.8" ];
        publicKey = "rehxjeDL+mEou+mdN3aweVIqQJTbxtugl34so29t+ho=";
        peers = {
          icebear = {
            publicKey = "VTGB/32zMWLXa7Yw23m8+saHCyLg4K/75teuRvsaAC0=";
            ip = "10.0.0.2";
          };
          pixel8a = {
            publicKey = "BH0y6vScdQQGyN65kJIGmpUioilpFueZGhO3eyTRVVA=";
            ip = "10.0.0.3";
          };
          homeserver = {
            publicKey = "PtHvWiCB1LetxHa+/CSd44cUt+xlk40te04wNq+hrT8=";
            ip = "10.0.0.4";
          };
          nixremberg = {
            publicKey = "JCZKgxGGmg19TeZL5pfsdWxiMSC+PDHuKNKvNa6U20c=";
            ip = "10.0.0.5";
          };
          rpi = {
            publicKey = "n1DhzVyfjCTnie17sAmfhaOB4MhK+/j2i0uw4tJy41c=";
            ip = "10.0.0.6";
          };
          nixtab = { # FIXME: make this have its own values.
            publicKey = "ATD2Drcv6UTGHKYAmn469ncwXUHLTrxTN8Ak9utiSFA=";
            ip = "10.0.0.7";
          };
          nixpad = {
            publicKey = "ATD2Drcv6UTGHKYAmn469ncwXUHLTrxTN8Ak9utiSFA=";
            ip = "10.0.0.8";
          };
        };
      };
      public = {
        host = private.host;
        port = 51830;
        network = "10.0.1.1/24";
        dns = private.dns;
        publicKey = "q2+htWSw7q+Va5rKG0kcVs9pYP6ITpp/5YR6J02jTHQ="; # FIXME This is wrong.
        peers = {
          homeserver = {
            publicKey = "6sBEBeUNbdHCHA/3MtiPG5enhzUAZnHsYdsFLDPo5Qk=";
            ip = "10.0.1.2";
          };
          emma-iphone = {
            publicKey = "M2mtkh4KLMPLCu9EcuT+KTLZnTMVLmgZ2smD3Dy00WY=";
            ip = "10.0.1.3";
          };
          emma-pc = {
            publicKey = "XHIH6NhlvpLai0T5GYQee5WwUlYIch1CqKKKLCJpM1s=";
            ip = "10.0.1.4";
          };
          emma-ipad = {
            publicKey = "vkbFz75wVitIZMDxMOkcI11yiDnehxG9+CcBeuGFAB8=";
            ip = "10.0.1.5";
          };
        };
      };
    };
  in {
    flake.nixosModules = {
      private-vpn-client = { config, ... }: {
        age.secrets = {
          "wg-private.${config.networking.hostName}.pre".file = ../secrets/wg-private.${config.networking.hostName}.pre.age;
          "wg-private.${config.networking.hostName}.pri".file = ../secrets/wg-private.${config.networking.hostName}.pri.age;
        };
        networking.wg-quick.interfaces.wg-private = let
            homeDir = if builtins.hasAttr "sergio" config.users.users then
                config.users.users.sergio.home
              else
                config.users.users.root.home;
          in {
            privateKeyFile = "${config.age.secrets."wg-private.${config.networking.hostName}.pri".path}";
            address = [ vpnData.private.peers.${config.networking.hostName}.ip ];
            dns = vpnData.private.dns;
            peers = [{
              publicKey = vpnData.private.publicKey;
              presharedKeyFile = "${config.age.secrets."wg-private.${config.networking.hostName}.pre".path}";
              allowedIPs = [ vpnData.private.network ];
              endpoint = "${vpnData.private.host}:${builtins.toString vpnData.private.port}";
              persistentKeepalive = 25;
            }];
          };
      };

      public-vpn-client = { config, ... }: {
        networking.wg-quick.interfaces.wg-public = let
            homeDir = if builtins.hasAttr "sergio" config.users.users then
                config.users.users.sergio.home
              else
                config.users.users.root.home;
          in {
            privateKeyFile = "${homeDir}/.config/wg/pri.key";
            address = [ vpnData.public.peers.${config.networking.hostName}.ip ];
            dns = vpnData.public.dns;
            peers = [{
              publicKey = vpnData.public.publicKey;
              presharedKeyFile = "${homeDir}/.config/wg/pre.key";
              allowedIPs = [ vpnData.public.network ];
              endpoint = "${vpnData.public.host}:${builtins.toString vpnData.public.port}";
              persistentKeepalive = 25;
            }];
          };
      };

      vpn-server = { config, ...}: {
        age.secrets = {
          "wg-private.pri".file = ../secrets/wg-private.pri.age;
          "wg-private.icebear.pre".file = ../secrets/wg-private.icebear.pre.age;
          "wg-private.pixel8a.pre".file = ../secrets/wg-private.pixel8a.pre.age;
          "wg-private.homeserver.pre".file = ../secrets/wg-private.homeserver.pre.age;
          "wg-private.nixremberg.pre".file = ../secrets/wg-private.nixremberg.pre.age;
          "wg-private.rpi.pre".file = ../secrets/wg-private.rpi.pre.age;
          "wg-private.nixtab.pre".file = ../secrets/wg-private.nixtab.pre.age;
          "wg-private.nixpad.pre".file = ../secrets/wg-private.nixpad.pre.age;

          "wg-public.pri".file = ../secrets/wg-public.pri.age;
          "wg-public.homeserver.pre".file = ../secrets/wg-public.homeserver.pre.age;
          "wg-public.emma-iphone.pre".file = ../secrets/wg-public.emma-iphone.pre.age;
          "wg-public.emma-pc.pre".file = ../secrets/wg-public.emma-pc.pre.age;
          "wg-public.emma-ipad.pre".file = ../secrets/wg-public.emma-ipad.pre.age;
        };
        networking = {
          firewall.allowedUDPPorts = [
            vpnData.private.port
            vpnData.public.port
          ];
          wg-quick.interfaces = lib.mkForce {};
          wireguard = {
            enable = true;
            interfaces = {
              private-wg = {
                listenPort = vpnData.private.port;
                privateKeyFile = "${config.age.secrets."wg-private.pri".path}";
                ips = [ vpnData.private.network ];
                peers = lib.mapAttrsToList (name: value: {
                    publicKey = value.publicKey;
                    presharedKeyFile = "${config.age.secrets."wg-private.${name}.pre".path}";
                    allowedIPs = [ "${value.ip}/32" ];
                  }) vpnData.private.peers;
              };
              public-wg = {
                listenPort = vpnData.public.port;
                privateKeyFile = "${config.age.secrets."wg-public.pri".path}";
                ips = [ vpnData.public.network ];
                peers = lib.mapAttrsToList (name: value: {
                    publicKey = value.publicKey;
                    presharedKeyFile = "${config.age.secrets."wg-public.${name}.pre".path}";
                    allowedIPs = [ "${value.ip}/32" ];
                  }) vpnData.public.peers;
              };
            };
          };
        };
      };
    };
  }
