{ ... }: {
  flake.nixosModules.linode = { config, pkgs, ... }: {
    age.secrets.ntfy.file = ../../secrets/ntfy.age;
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "http://10.0.0.9";
        listen-http = "10.0.0.9:8001";
      };
      environmentFile = "${config.age.secrets.ntfy.path}";
    };
    networking.firewall.allowedTCPPorts = [ 8001 ];

    systemd = {
      services.aerotermia-check = {
        description = "Check Xunta aerotermia grant availability";
        path = [ pkgs.curl ];
        script = ''
          body=$(curl -s 'https://sede.xunta.gal/detalle-procedemento?codtram=VI406E&ano=2025')
          if ! grep -q 'O recurso solicitado non foi atopado' <<<"$body"; then
            curl -d '*Ayudas aerotermia* disponibles!' http://10.0.0.9:8001/alerts
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
        };
      };
      timers.aerotermia-check = {
        description = "Run aerotermia check periodically";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "15m";
          Persistent = true;
        };
      };
    };
  };
}
