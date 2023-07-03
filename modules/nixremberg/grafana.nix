{ self, inputs, lib, ... }: {
  flake.nixosModules.nixremberg = { config, modulesPath, ... }: {
    services = {
      grafana = {
        enable = true;
        settings.server = {
          http_addr = "10.0.0.1"; # TODO Get this.
          http_port = 3000;
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


    networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}
