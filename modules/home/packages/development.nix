{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools
    claude-code
    code-cursor
    cursor-cli
    direnv
    openssh
    (python3.withPackages (pythonPackages: [ pythonPackages.i3ipc ]))
  ];
}
