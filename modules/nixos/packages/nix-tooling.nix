{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    home-manager
    nix-direnv
    nixfmt
  ];
}
