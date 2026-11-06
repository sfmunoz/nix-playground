{ system ? "x86_64-linux" }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
derivation {
  name = "hello-c";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ];
  inherit (pkgs) coreutils gcc;
  src = ./src/main.c;
  inherit system;
}
