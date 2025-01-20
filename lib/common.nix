{ pkgs, home-manager, ... }:
{
  nixpkgs.config.allowUnfree = true;
  programs.noisetorch.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.tornado711 = {
    home.packages = with pkgs; [
      code-cursor
      direnv
      file
      librewolf
      obsidian
      openssh
      android-udev-rules
      python314
      signal-desktop
      todoist-electron
    ];
    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = true;

    xdg.desktopEntries.nemo = { 
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
};

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        userSettings = {
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.profiles.linux" = {
            "nix-shell" = {
              "path" = "nix-shell";
            };
            "zsh" = {
              "path" = "${pkgs.zsh}/bin/zsh";
            };
          };
          "terminal.integrated.inheritEnv" = true;
          "workbench.iconTheme" = "vscode-icons";
          "dotnet.server.path" = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
          "omnisharp.useGlobalMono" = "always";
          "editor.minimap.enabled" = false;
          "dotnet.server.useOmnisharp" = true;
        };
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          dracula-theme.theme-dracula
          vscodevim.vim
          vscode-icons-team.vscode-icons
          ms-dotnettools.csharp
          ms-dotnettools.csdevkit
          continue.continue
        ];
      };
    };

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "nlgphodeccebbcnkgmokeegopgpnjfkc"; } # Super dark mode
        { id = "eiaeiblijfjekdanodkjadfinkhbfgcd"; } # NordPass
        { id = "ljflmlehinmoeknoonhibbjpldiijjmm"; } # Speechify
      ];
    };
  };
}
