{
  description = "getchoo's modpack";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    packwiz2nix = {
      url = "github:getchoo/packwiz2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    packwiz2nix,
    self,
    ...
  }: let
    inherit (nixpkgs) lib;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = fn: lib.genAttrs systems (s: fn nixpkgs.legacyPackages.${s});
  in {
    packages = forAllSystems (pkgs: let
      inherit (pkgs.stdenv.hostPlatform) system;

      inherit
        (packwiz2nix.lib.${system})
        fetchPackwizModpack
        mkMultiMCPack
        ;
    in {
      modpack = fetchPackwizModpack {
        manifest = "${self}/pack.toml";
        hash = "sha256-NVfgazU/mYs8rGBKNBgV+za+T4tmNLDPA8gz0699ZJs=";
      };

      modpack-zip = mkMultiMCPack {
        src = self.packages.${system}.modpack;
        instanceCfg = ./files/instance.cfg;
      };

      default = self.packages.${system}.modpack-zip;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          packwiz
          unzip
          zip
        ];
      };
    });
  };
}
