{ self, inputs, lib, ... }: {
  flake.nixosModules.linode = { config, modulesPath, ... }: {
    services = {
      grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "10.0.0.9"; # TODO Get this.
            http_port = 3000;
          };
          # FIXME: This being exposed is not that important but I would rather
          #        have it managed by agenix.
          security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
        };
      };
      prometheus = {
        enable = true;
        scrapeConfigs = [{
          job_name = "node";
          static_configs = [{
            targets = [ "localhost:9100" ];
          }];
        }];
        exporters.node = {
          enable = true;
          enabledCollectors = [ "filesystem" "diskstats" ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      3000
    ];
  };
}
