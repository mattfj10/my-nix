{
  config,
  lib,
  pkgs,
  ...
}:
let
  articleFullText = pkgs.freshrss-extensions.buildFreshRssExtension {
    FreshRssExtUniqueId = "Af_Readability";
    pname = "freshrss-af-readability";
    version = "0.4-unstable-2026-06-17";
    src = pkgs.fetchFromGitHub {
      hash = "sha256-ObYg/5miZq2phKYwn1KBWCEyqe6xDMPbu7r6uv3wyxY=";
      owner = "Niehztog";
      repo = "freshrss-af-readability";
      rev = "2843fa0b22da5f419228ce2c90501435f16fd5de";
    };
  };
  isDesktop = !config.nixnado.isLaptop;
  passwordFile = "/var/lib/freshrss/admin-password";
in
{
  config = lib.mkIf isDesktop {
    services.freshrss = {
      api.enable = true;
      baseUrl = "https://rss.mattforresterjones.com";
      enable = true;
      extensions = [ articleFullText ];
      inherit passwordFile;
      virtualHost = "rss.mattforresterjones.com";
    };

    systemd.services.freshrss-config.preStart = ''
      if [[ ! -s ${passwordFile} ]]; then
        umask 077
        ${pkgs.openssl}/bin/openssl rand -base64 24 > ${passwordFile}
      fi
    '';
  };
}
