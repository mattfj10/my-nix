{
  host,
  lib,
  pkgs,
}:
{
  enable = true;
  package = pkgs.polybar.override {
    i3Support = true;
    pulseSupport = true;
  };
  script = "polybar main &";
  settings = {
    "bar/main" = {
      background = "\${colors.background}";
      border-color = "\${colors.background}";
      border-size = "6pt";
      bottom = true;
      cursor-click = "pointer";
      cursor-scroll = "ns-resize";
      enable-ipc = true;
      font-0 = "monospace:size=16;2";
      foreground = "\${colors.foreground}";
      height = "24pt";
      line-size = "4pt";
      module-margin = 2;
      modules-left = "xworkspaces i3 xwindow";
      modules-right =
        if host.isLaptop then
          "filesystem pulseaudio xkeyboard memory cpu wlan eth battery date tray"
        else
          "filesystem pulseaudio xkeyboard memory cpu wlan eth date tray";
      padding-left = 0;
      padding-right = 2;
      radius = 6;
      separator = "|";
      separator-foreground = "\${colors.disabled}";
      width = "100%";
    };

    colors = {
      alert = "#A54242";
      background = "#80373b41";
      background-alt = "#373be1";
      disabled = "#707880";
      foreground = "#C5C8C6";
      primary = "#2e92d1";
      secondary = "#8ABEB7";
    };

    "module/cpu" = {
      format-prefix = "CPU ";
      format-prefix-foreground = "\${colors.primary}";
      interval = 2;
      label = "%percentage:2%%";
      type = "internal/cpu";
    };

    "module/date" = {
      date = "%Y-%m-%d %H:%M:%S";
      date-alt = "%Y-%m-%d %H:%M:%S";
      interval = 1;
      label = "%date%";
      label-foreground = "\${colors.primary}";
      type = "internal/date";
    };

    "module/filesystem" = {
      fixed-values = true;
      interval = 30;
      label-mounted = "%free% (%percentage_used%%)";
      label-mounted-foreground = "\${colors.primary}";
      label-unmounted = "not mounted";
      label-unmounted-foreground = "\${colors.alert}";
      mount-0 = "/";
      spacing = 2;
      type = "internal/fs";
      warn-percentage = 90;
    };

    "module/i3" = {
      format = "<label-mode>";
      label-mode = "%mode%";
      label-mode-background = "\${colors.alert}";
      label-mode-padding = 2;
      type = "internal/i3";
    };

    "module/memory" = {
      format-prefix = "RAM ";
      format-prefix-foreground = "\${colors.primary}";
      interval = 2;
      label = "%used% (%percentage_used:2%%)";
      type = "internal/memory";
    };

    "module/pulseaudio" = {
      bar-volume-empty = "─";
      bar-volume-empty-font = 2;
      bar-volume-empty-foreground = "#666";
      bar-volume-fill = "─";
      bar-volume-filled = "─";
      bar-volume-indicator = "|";
      bar-volume-width = 10;
      format-volume = "<bar-volume> <label-volume>";
      format-volume-prefix = "VOL ";
      format-volume-prefix-foreground = "\${colors.primary}";
      label-muted = "muted";
      label-muted-foreground = "\${colors.disabled}";
      label-volume = "%percentage%%";
      type = "internal/pulseaudio";
    };

    "module/tray" = {
      format-margin = "12px";
      tray-size = "140%";
      tray-spacing = "12px";
      type = "internal/tray";
    };

    "module/wlan" = {
      format-connected = "<ramp-signal> <label-connected>";
      format-connected-underline = "#9f78e1";
      format-disconnected = "";
      interface = "wlan0";
      interval = "3.0";
      label-connected = "%essid%";
      ramp-signal-0 = "";
      ramp-signal-1 = "";
      ramp-signal-2 = "";
      ramp-signal-3 = "";
      ramp-signal-4 = "";
      ramp-signal-foreground = "\${colors.primary}";
      type = "internal/network";
    };

    "module/xwindow" = {
      label = "%title:0:60:...%";
      type = "internal/xwindow";
    };

    "module/xworkspaces" = {
      label-active = "%name%";
      label-active-background = "\${colors.primary}";
      label-active-padding = 1;
      label-active-underline = "#00000000";
      label-empty = "%name%";
      label-empty-foreground = "\${colors.disabled}";
      label-empty-padding = 1;
      label-occupied = "%name%";
      label-occupied-padding = 1;
      label-urgent = "%name%";
      label-urgent-background = "\${colors.alert}";
      label-urgent-padding = 1;
      type = "internal/xworkspaces";
    };

    settings = {
      pseudo-transparency = true;
      screenchange-reload = true;
    };
  }
  // lib.optionalAttrs host.isLaptop {
    "module/battery" = {
      adapter = "AC";
      battery = "BAT0";
      format-charging = "<ramp-capacity> <label-charging>";
      format-charging-foreground = "\${colors.primary}";
      format-discharging = "<ramp-capacity> <label-discharging>";
      format-discharging-foreground = "\${colors.primary}";
      format-full = "<ramp-capacity> <label-full>";
      format-full-foreground = "\${colors.primary}";
      full-at = 98;
      label-charging = "CHR %percentage%%";
      label-discharging = "BAT %percentage%%";
      label-full = "BAT %percentage%%";
      poll-interval = 5;
      ramp-capacity-0 = "▁";
      ramp-capacity-1 = "▂";
      ramp-capacity-2 = "▃";
      ramp-capacity-3 = "▄";
      ramp-capacity-4 = "▅";
      ramp-capacity-foreground = "\${colors.primary}";
      type = "internal/battery";
    };
  };
}
