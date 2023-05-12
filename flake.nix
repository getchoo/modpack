{
  description = "getchoo's modpack";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    packwiz2nix.url = "github:getchoo/packwiz2nix";
  };

  outputs = {
    nixpkgs,
    packwiz2nix,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
    inherit (packwiz2nix.lib) mkChecksumsApp mkMultiMCPack mkPackwizPackages;
  in {
    apps = forAllSystems (s: let
      pkgs = nixpkgsFor.${s};
    in {
      generate-checksums = mkChecksumsApp pkgs ./mods;
    });

    packages = forAllSystems (s: let
      pkgs = nixpkgsFor.${s};
      mods = mkPackwizPackages pkgs ./checksums.json;
    in rec {
      getchoo-modpack = mkMultiMCPack {
        inherit pkgs mods;
        filesDir = ./files;
        name = "getchoo-modpack";
      };

      default = getchoo-modpack;
    });

    devShells = forAllSystems (s: let
      pkgs = nixpkgsFor.${s};
      inherit (pkgs) mkShell;
    in {
      default = mkShell {
        packages = with pkgs; [
          packwiz
          p7zip
        ];
      };
    });
  };
}
