{ system ? "x86_64-linux" }:

let
  pkgs = import <nixpkgs> { inherit system; };
  inherit (pkgs) bash;  # bash = pkgs.bash
in
derivation {
  name = "builder-sh";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  inherit system;
}
