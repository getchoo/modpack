{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
}:

pkgs.mkShellNoCC {
  packages = [ pkgs.packwiz ];
}
