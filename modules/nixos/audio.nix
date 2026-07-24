{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services = {
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      extraConfig.pipewire."99-input-denoising"."context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
            };
            "filter.graph".nodes = [
              {
                control = {
                  "Retroactive VAD Grace (ms)" = 0;
                  "VAD Grace Period (ms)" = 200;
                  "VAD Threshold (%)" = 50;
                };
                label = "noise_suppressor_mono";
                name = "rnnoise";
                plugin = "librnnoise_ladspa";
                type = "ladspa";
              }
            ];
            "media.name" = "Noise Canceling Source";
            "node.description" = "Noise Canceling Source";
            "playback.props" = {
              "media.class" = "Audio/Source";
              "node.name" = "rnnoise_source";
            };
          };
        }
      ];
      extraLadspaPackages = [ pkgs.rnnoise-plugin.ladspa ];
      pulse.enable = true;
    };
    pulseaudio.enable = false;
  };
}
