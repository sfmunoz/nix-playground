# hello-sh

## hello-sh → hello-sh-flake

`diff -u hello-sh/default.nix hello-sh-flake/default.nix`:

```diff
--- hello-sh/default.nix        2026-11-06 17:28:21.857035780 +0000
+++ hello-sh-flake/default.nix  2026-11-06 19:02:49.360454863 +0000
@@ -1,8 +1,5 @@
-{ system ? "x86_64-linux" }:
+{ pkgs }:

-let
-  pkgs = import <nixpkgs> { inherit system; };
-in
 derivation {
   name = "hello.sh";
   builder = "${pkgs.bash}/bin/bash";
@@ -15,5 +12,5 @@
       chmod +x "$out/bin/hello.sh"
     ''
   ];
-  inherit system;
+  system = pkgs.stdenv.hostPlatform.system;
 }
```

## Build

```
$ nix-build
this derivation will be built:
  /nix/store/iwyd1b3880yy1ppik8wnb1z5w4lasqgr-hello.sh.drv
building '/nix/store/iwyd1b3880yy1ppik8wnb1z5w4lasqgr-hello.sh.drv'...
/nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh
```

`nix-build` leaves a `result` symlink pointing to the output, which is a
directory:

```
$ ls -l result
lrwxrwxrwx 1 i12e users 52 Nov  3 19:45 result -> /nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh

$ find -L result
result
result/bin
result/bin/hello.sh

$ ./result/bin/hello.sh
hello world
```
