{
  description = "getchoo's modpack";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    packwiz2nix.url = "github:getchoo/packwiz2nix";
  };

  outputs = {
    self,
    nixpkgs,
    packwiz2nix,
    ...
  }: let
    version = self.lastModifiedDate;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    apps = forAllSystems (s: let
      pkgs = nixpkgsFor.${s};
    in {
      generate-checksums = packwiz2nix.lib.mkChecksumsApp pkgs ./mods;
    });

    packages = forAllSystems (s: let
      pkgs = nixpkgsFor.${s};
    in rec {
      getchoo-modpack = pkgs.callPackage ./nix {inherit version;};
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
