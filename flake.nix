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
        ];
      };
    in
    {
      nixosConfigurations.nixnado = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          ./lib/common.nix
          ./lib/tools.nix
          ./system/system.nix
          ./lib/media.nix
          ./scripts/i3-scripts.nix
          ./hardware-configuration.nix
          # Apply overlays to the system
          { nixpkgs.overlays = [ (import ./overlays/i3ipc.nix) ]; }
        ];
      };
    };
}
