{ ... }: {
  flake.nixosModules.aerc = { ... }: {
    home-manager.users.sergio.programs.aerc = {
      enable = true;
      extraConfig = {
        general.unsafe-accounts-conf = true; # Required for it to run.
        ui = {
          sort = "-r date";
          threading-enabled = true;
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/html" = "pandoc -f html -t plain | colorize";
          "image/*" = "catimg -w $(tput cols) -";
          ".headers" = "colorize";
        };
      };
      extraBinds = {
        global = {
          "<C-p>" = ":prev-tab<Enter>";
          "<C-PgUp>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          "<C-PgDn>" = ":next-tab<Enter>";
          "\\[t" = ":prev-tab<Enter>";
          "\\]t" = ":next-tab<Enter>";
          "<C-t>" = ":term<Enter>";
          "?" = ":help keys<Enter>";
          "<C-c>" = ":prompt 'Quit?' quit<Enter>";
          "<C-q>" = ":prompt 'Quit?' quit<Enter>";
          "<C-z>" = ":suspend<Enter>";
        };
        messages = {
          q = ":quit<Enter>";

          j = ":next<Enter>";
          "<Down>" = ":next<Enter>";
          "<C-d>" = ":next 50%<Enter>";
          "<C-f>" = ":next 100%<Enter>";
          "<PgDn>" = ":next 100%<Enter>";

          k = ":prev<Enter>";
          "<Up>" = ":prev<Enter>";
          "<C-u>" = ":prev 50%<Enter>";
          "<C-b>" = ":prev 100%<Enter>";
          "<PgUp>" = ":prev 100%<Enter>";
          gg = ":select 0<Enter>";
          G = ":select -1<Enter>";

          J = ":next-folder<Enter>";
          "<C-Down>" = ":next-folder<Enter>";
          K = ":prev-folder<Enter>";
          "<C-Up>" = ":prev-folder<Enter>";
          H = ":collapse-folder<Enter>";
          "<C-Left>" = ":collapse-folder<Enter>";
          L = ":expand-folder<Enter>";
          "<C-Right>" = ":expand-folder<Enter>";

          v = ":mark -t<Enter>";
          "<Space>" = ":mark -t<Enter>:next<Enter>";
          V = ":mark -v<Enter>";

          T = ":toggle-threads<Enter>";
          zc = ":fold<Enter>";
          zo = ":unfold<Enter>";
          za = ":fold -t<Enter>";
          zM = ":fold -a<Enter>";
          zR = ":unfold -a<Enter>";
          "<tab>" = ":fold -t<Enter>";

          "<Enter>" = ":view<Enter>";
          d = ":prompt 'Really delete this message?' 'delete-message'<Enter>";
          D = ":delete<Enter>";
          a = ":archive flat<Enter>";
          A = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>";
          i = ":flag -tx flagged<Enter>";

          C = ":compose<Enter>";
          m = ":compose<Enter>";

          rq = ":reply -aq<Enter>";
          rr = ":reply -a<Enter>";

          c = ":cf<space>";
          "$" = ":term<space>";
          "!" = ":term<space>";
          "|" = ":pipe<space>";

          "/" = ":search<space>";
          "\\" = ":filter<space>";
          n = ":next-result<Enter>";
          N = ":prev-result<Enter>";
          "<Esc>" = ":clear<Enter>";

          s = ":split<Enter>";
          S = ":vsplit<Enter>";

          pl = ":patch list<Enter>";
          pa = ":patch apply <Tab>";
          pd = ":patch drop <Tab>";
          pb = ":patch rebase<Enter>";
          pt = ":patch term<Enter>";
          ps = ":patch switch <Tab>";
        };
        "messages:folder=Drafts" = {
          "<Enter>" = ":recall<Enter>";
        };
        view = {
          A = ":archive flat<Enter>";
          D = ":delete<Enter>";
          O = ":open<Enter>";
          o = ":open-link<Space><Space>";
          q = ":close<Enter>";
          S = ":save<space>";
          "|" = ":pipe<space>";
          "/" = ":toggle-key-passthrough<Enter>/";

          "<C-l>" = ":open-link <space>";

          rq = ":reply -aq<Enter>";
          rr = ":reply -a<Enter>";

          H = ":toggle-headers<Enter>";
          "<C-k>" = ":prev-part<Enter>";
          "<C-Up>" = ":prev-part<Enter>";
          "<C-j>" = ":next-part<Enter>";
          "<C-Down>" = ":next-part<Enter>";
          J = ":next<Enter>";
          "<C-Right>" = ":next<Enter>";
          K = ":prev<Enter>";
          "<C-Left>" = ":prev<Enter>";
        };
        "view::passthrough" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<Esc>" = ":toggle-key-passthrough<Enter>";
        };
        compose = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "$complete" = "<C-o>";
          "<C-k>" = ":prev-field<Enter>";
          "<C-Up>" = ":prev-field<Enter>";
          "<C-j>" = ":next-field<Enter>";
          "<C-Down>" = ":next-field<Enter>";
          "<A-p>" = ":switch-account -p<Enter>";
          "<C-Left>" = ":switch-account -p<Enter>";
          "<A-n>" = ":switch-account -n<Enter>";
          "<C-Right>" = ":switch-account -n<Enter>";
          "<tab>" = ":next-field<Enter>";
          "<backtab>" = ":prev-field<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-PgUp>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          "<C-PgDn>" = ":next-tab<Enter>";
        };
        "compose::editor" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-k>" = ":prev-field<Enter>";
          "<C-Up>" = ":prev-field<Enter>";
          "<C-j>" = ":next-field<Enter>";
          "<C-Down>" = ":next-field<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-PgUp>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          "<C-PgDn>" = ":next-tab<Enter>";
        };
        "compose::review" = {
          y = ":send<Enter>";
          n = ":abort<Enter>";
          v = ":preview<Enter>";
          p = ":postpone<Enter>";
          q = ":choose -o d discard abort -o p postpone postpone<Enter>";
          e = ":edit<Enter>";
          a = ":attach<space>";
          d = ":detach<space>";
        };
      };
    };
  };
}
