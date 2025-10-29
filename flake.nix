{
  description = "A simple development workspace for working with Hugo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      devShell = pkgs.mkShell {
        # Packages to install
        buildInputs = [
          pkgs.hugo

          # Favicon generation
          pkgs.imagemagick
          pkgs.xmlstarlet
        ];
      };
    });
}
