{ config, lib, ... }:
let
  isDesktop = !config.nixnado.isLaptop;
in
{
  config = lib.mkIf isDesktop {
    security.acme = {
      acceptTerms = true;
      defaults.email = "mattfjones@protonmail.com";
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      streamConfig = ''
        server {
          listen 2222;
          proxy_pass 127.0.0.1:22;
          proxy_timeout 24h;
        }
      '';

      virtualHosts = {
        "calibre.mattforresterjones.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            extraConfig = "client_max_body_size 100M;";
            proxyPass = "http://127.0.0.1:8083";
            proxyWebsockets = true;
          };
        };

        "jellyfin.mattforresterjones.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            extraConfig = ''
              proxy_buffering off;
              client_max_body_size 20M;
            '';
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true;
          };
        };

        "podcasts.mattforresterjones.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            extraConfig = ''
              proxy_buffering off;
              client_max_body_size 100M;
            '';
            proxyPass = "http://127.0.0.1:8040";
            proxyWebsockets = true;
          };
        };

        "rss.mattforresterjones.com" = {
          enableACME = true;
          forceSSL = true;
        };
      };
    };
  };
}
