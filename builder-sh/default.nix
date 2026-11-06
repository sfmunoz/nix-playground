let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) bash;  # bash = pkgs.bash
in
derivation {
  name = "builder-sh";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  system = builtins.currentSystem;
}
