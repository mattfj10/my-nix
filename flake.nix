{
  description = "My system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nvf,
      neovim-nightly-overlay,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          (import ./overlays/i3ipc.nix)
          (import ./overlays/freetube.nix)
        ];
      };

      baseModules = [
        ./configuration.nix
        home-manager.nixosModules.default
        ./lib/common.nix
        ./lib/tools.nix
        ./system/system.nix
        ./lib/media.nix
        ./scripts/i3-scripts.nix
        { nixpkgs.overlays = [
          (import ./overlays/i3ipc.nix)
          (import ./overlays/freetube.nix)
        ]; }
      ];

      mkNixnado = host: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit host;
        };
        modules = baseModules ++ [ host.hardwareConfig ];
      };
    in
    {
      nixosConfigurations.nixnado_desktop = mkNixnado {
        name = "nixnado_desktop";
        isLaptop = false;
        hasNvidia = true;
        hardwareConfig = ./hardware-configuration-desktop.nix;
      };

      nixosConfigurations.nixnado_laptop = mkNixnado {
        name = "nixnado_laptop";
        isLaptop = true;
        hasNvidia = false;
        hardwareConfig = ./hardware-configuration-laptop.nix;
      };
    };
}
