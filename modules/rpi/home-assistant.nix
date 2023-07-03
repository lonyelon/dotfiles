{ self, inputs, ... }: {
  flake.nixosModules.rpi = {
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
          "syncthing"
          "speedtestdotnet"
          "minecraft_server"
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
