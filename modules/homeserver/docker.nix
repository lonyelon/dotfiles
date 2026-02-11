{ self, config, inputs, lib, pkgs, ... }: {
  flake = {
    nixosModules.homeserver = { config, pkgs, lib, modulesPath, ... }: let
        localAddress = "192.168.1.200";
        privateVpnAddress = builtins.elemAt config.networking.wg-quick.interfaces.wg-private.address 0;
        publicVpnAddress = builtins.elemAt config.networking.wg-quick.interfaces.wg-public.address 0;
        dockerComposeFile = ../../files/homeserver/docker-compose.yaml;
        mountFile = pkgs.replaceVars ../../files/homeserver/mount.sh {
          dockerComposeFile = "/run/sergio/docker-compose.yaml";
        };
      in {
        age.secrets."homeserver-docker".file = ../../secrets/homeserver-docker.age;

        environment.variables.COMPOSE_FILE = "/run/sergio/docker-compose.yaml";

        system.activationScripts."docker-compose-secret" = ''
          mkdir -p /run/sergio
          cp ${dockerComposeFile} /run/sergio/docker-compose.yaml

          function replace_secret () {
            value="$2"
            [ -z "$2" ] && value="$(
                ${pkgs.gnugrep}/bin/grep $1 "${config.age.secrets."homeserver-docker".path}" \
                  | ${pkgs.coreutils}/bin/cut -d' ' -f2
                )"
            ${pkgs.gnused}/bin/sed -i "s#@$1@#$value#" "/run/sergio/docker-compose.yaml"
          }

          replace_secret nextcloud_mariadb_password
          replace_secret nextcloud_mariadb_root_password
          replace_secret forgejo_mariadb_password
          replace_secret forgejo_mariadb_root_password
          replace_secret transmission_password
          replace_secret localAddress ${localAddress}
          replace_secret privateVpnAddress ${privateVpnAddress}
          replace_secret publicVpnAddress ${publicVpnAddress}
        '';

        systemd.services.unlock-raid-and-launch-containers = {    
          description = "Unlock LUKS encripted raid, mount volumes, and launch Docker services on boot.";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "/bin/sh ${mountFile}";
            Environment = "PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH";
          };
        };

        virtualisation.docker.enable = true;
      };
  };
}
