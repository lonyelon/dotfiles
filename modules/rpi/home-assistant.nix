{ self, inputs, ... }: {
  flake.nixosModules.rpi = { pkgs, ... }: {
    services = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        config = {
          default_config = {};
          automation = "!include automations.yaml";
          script = "!include scripts.yaml";
          input_boolean.vacation_mode = {
            name = "Wether to enable the vacation mode.";
            initial = false;
            icon = "mdi:car";
          };
          homeassistant.allowlist_external_dirs = [
            "/var/lib/hass/snapshots"
          ];
        };
        extraComponents = [
          "esphome"
          "met"
          "radio_browser"
          "zwave_js"
          "wake_on_lan"
          "samsungtv"
          "ipp"
          "holiday"
          "minecraft_server"
          "reolink"
          "isal"
        ];
      };
      zwave-js = {
        enable = true;
        serialPort = "/dev/ttyACM0";
        secretsConfigFile = "/etc/zwave.json";
      };
    };
    systemd = {
      services.hass-snapshot-cleanup = {
        description = "Delete Home Assistant snapshots older than 30 days";
        script = "find /var/lib/hass/snapshots -maxdepth 1 -mtime +30 -delete";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
      timers.hass-snapshot-cleanup = {
        description = "Run hass-snapshot-cleanup every hour";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };
    };
  };
}
