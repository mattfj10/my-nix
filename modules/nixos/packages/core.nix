{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    config.boot.kernelPackages.kernel.dev
    rar
    tmux
    vim
    wget
  ];
}
