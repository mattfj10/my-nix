{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    config.boot.kernelPackages.kernel.dev
    rar
    vim
    wget
  ];
}
