{ config, lib, ... }:
let
  isDesktop = !config.nixnado.isLaptop;
in
{
  config = lib.mkIf isDesktop {
    services.openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  };
}
