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
  };
}
