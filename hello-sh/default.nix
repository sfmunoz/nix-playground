let
  pkgs = import <nixpkgs> { };
in
derivation {
  name = "hello.sh";
  builder = "${pkgs.bash}/bin/bash";
  args = [
    "-c"
    ''
      export PATH=${pkgs.coreutils}/bin
      mkdir -p "$out/bin"
      printf '#!/bin/sh\necho "hello world"\n' > "$out/bin/hello.sh"
      chmod +x "$out/bin/hello.sh"
    ''
  ];
  system = "x86_64-linux";
}
