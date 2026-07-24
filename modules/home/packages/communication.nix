{ pkgs, pkgsSignal, ... }:
{
  home.packages = [
    pkgs.discord
    pkgsSignal.signal-desktop
    pkgs.slack
    pkgs.todoist-electron
  ];
}
