{
  config,
  lib,
  pkgs,
  ...
}:
let
  containerUnits = [
    "podman-pinepods-db.service"
    "podman-pinepods-valkey.service"
    "podman-pinepods.service"
  ];
  isDesktop = !config.nixnado.isLaptop;
  networkName = "pinepods";
  secretsFile = "/var/lib/pinepods/secrets.env";
in
{
  config = lib.mkIf isDesktop {
    systemd.services = {
      pinepods-network = {
        before = containerUnits;
        description = "Create the PinePods Podman network";
        requiredBy = containerUnits;
        serviceConfig = {
          RemainAfterExit = true;
          Type = "oneshot";
        };
        script = ''
          ${pkgs.podman}/bin/podman network inspect ${networkName} >/dev/null 2>&1 \
            || ${pkgs.podman}/bin/podman network create ${networkName}
        '';
      };

      pinepods-secrets = {
        before = [
          "podman-pinepods-db.service"
          "podman-pinepods.service"
        ];
        description = "Generate PinePods database credentials";
        requiredBy = [
          "podman-pinepods-db.service"
          "podman-pinepods.service"
        ];
        serviceConfig = {
          RemainAfterExit = true;
          StateDirectory = "pinepods";
          Type = "oneshot";
          UMask = "0077";
        };
        script = ''
          if [[ ! -s ${secretsFile} ]]; then
            password="$(${pkgs.openssl}/bin/openssl rand -hex 32)"
            {
              printf 'POSTGRES_PASSWORD=%s\n' "$password"
              printf 'DB_PASSWORD=%s\n' "$password"
            } > ${secretsFile}
          fi
        '';
      };
    };

    virtualisation.oci-containers.containers = {
      pinepods = {
        dependsOn = [
          "pinepods-db"
          "pinepods-valkey"
        ];
        environment = {
          DB_HOST = "pinepods-db";
          DB_NAME = "pinepods_database";
          DB_PORT = "5432";
          DB_TYPE = "postgresql";
          DB_USER = "pinepods";
          DEBUG_MODE = "false";
          DEFAULT_LANGUAGE = "en";
          HOSTNAME = "https://podcasts.mattforresterjones.com";
          PEOPLE_API_URL = "https://people.pinepods.online";
          PGID = "100";
          PUID = "1000";
          SEARCH_API_URL = "https://search.pinepods.online/api/search";
          TZ = "America/New_York";
          VALKEY_HOST = "pinepods-valkey";
          VALKEY_PORT = "6379";
        };
        environmentFiles = [ secretsFile ];
        image = "docker.io/madeofpendletonwool/pinepods:0.9.0";
        networks = [ networkName ];
        ports = [ "127.0.0.1:8040:8040" ];
        pull = "newer";
        volumes = [
          "pinepods-backups:/opt/pinepods/backups"
          "pinepods-downloads:/opt/pinepods/downloads"
        ];
      };

      pinepods-db = {
        environment = {
          PGDATA = "/var/lib/pgdata/pgdata";
          POSTGRES_DB = "pinepods_database";
          POSTGRES_USER = "pinepods";
        };
        environmentFiles = [ secretsFile ];
        image = "docker.io/library/postgres:18";
        networks = [ networkName ];
        pull = "newer";
        volumes = [ "pinepods-postgres:/var/lib/pgdata" ];
      };

      pinepods-valkey = {
        image = "docker.io/valkey/valkey:8-alpine";
        networks = [ networkName ];
        pull = "newer";
      };
    };
  };
}
