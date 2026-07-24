{
  config,
  pkgs,
  pkgsSignal,
  ...
}:
let
  localPkgs = import ../../pkgs { inherit pkgs; };
in
{
  home-manager = {
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      host = config.nixnado;
      inherit localPkgs pkgsSignal;
    };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.tornado711 = {
      home = {
        enableNixpkgsReleaseCheck = true;
        file.".cursor/skills" = {
          recursive = true;
          source = ../../cursor/skills;
        };
        stateVersion = "24.11";
      };

      imports = [
        ./appearance.nix
        ./desktop.nix
        ./packages/browsers.nix
        ./packages/communication.nix
        ./packages/desktop.nix
        ./packages/development.nix
        ./packages/gaming.nix
        ./packages/media.nix
        ./packages/productivity.nix
        ./packages/security.nix
        ./packages/utilities.nix
        ./packages/virtualization.nix
        ./programs/browsers.nix
        ./programs/development.nix
        ./programs/shell.nix
      ];
    };
  };
}
