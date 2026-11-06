let
  pkgs = import <nixpkgs> { };
in
derivation {
  name = "hello-c";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ];
  inherit (pkgs) coreutils gcc;
  src = ./src/main.c;
  system = builtins.currentSystem;
}
