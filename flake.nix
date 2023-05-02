{
  description = "getchoo's modpack";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
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
    packages = forAllSystems (s: let
      pkgs = nixpkgsFor.${s};
    in {
      getchoo-modpack = pkgs.callPackage ./nix {inherit version;};
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
