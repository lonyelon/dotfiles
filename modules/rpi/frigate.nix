{ self, inputs, ... }: {
  flake.nixosModules.frigate = { config, ... }: {
    services = {
      frigate = {
        enable = true;
        hostname = "frigate";
        settings = {
          mqtt = {
            enabled = true;
            host = "127.0.0.1";
            user = "frigate";
            password = "frigate";
          };

          detectors.cpu1.type = "cpu";

          record = {
            enabled = true;
            retain = {
              days = 0;
              mode = "all";
            };
            alerts.retain = {
              days = 30;
              mode = "motion";
            };
            detections.retain = {
              days = 14;
              mode = "motion";
            };
          };

          cameras.living-room = {
            ffmpeg.inputs = [
              {
                path = "rtsp://admin:{FRIGATE_RTSP_PASSWORD}@192.168.1.209:554/h264Preview_01_main";
                roles = [ "record" ];
              }
              {
                path = "rtsp://admin:{FRIGATE_RTSP_PASSWORD}@192.168.1.209:554/h264Preview_01_sub";
                roles = [ "detect" ];
              }
            ];

            detect = {
              enabled = true;
              width = 896;
              height = 512;
              fps = 5;
            };

            snapshots.enabled = true;
          };

          version = "0.16-1";
        };
      };

      nginx.virtualHosts = {
        "frigate-lan" = {
          listen = [
            { addr = "0.0.0.0"; port = 8080; }
          ];
          default = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:5000";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
              proxy_read_timeout 3600s;
              proxy_send_timeout 3600s;
            '';
          };
        };
      };

      mosquitto = {
        enable = true;
        listeners = [{
          address = "127.0.0.1";
          port = 1883;
          users.frigate = {
            acl = [ "readwrite #" ];
            password = "frigate";
          };
        }];
      };
    };

    fileSystems."/var/lib/frigate/recordings" = {
      device = "/dev/disk/by-uuid/531df7c3-0ba9-4b19-b817-df586f4fa75e";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail" # Don't block boot if USB is unplugged.
        "x-systemd.device-timeout=10"
      ];
    };

    systemd = {
      # Ensure correct permissions for the directory.
      tmpfiles.rules = [
        "d /var/lib/frigate/recordings 0750 frigate frigate -"
      ];
      services = {
        frigate = {
          # Wait for the mountpoint before starting frigate.
          requires = [ "var-lib-frigate-recordings.mount" ];
          after = [ "var-lib-frigate-recordings.mount" ];
          # Use secret as env.
          serviceConfig.EnvironmentFile = config.age.secrets.frigate-env.path;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 8080 ];

    age.secrets.frigate-env = {
      file = ../../secrets/reolink.age;
      owner = "frigate";
      group = "frigate";
      mode = "0400";
    };
  };
}
