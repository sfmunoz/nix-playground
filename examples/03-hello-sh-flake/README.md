# hello-sh-flake

## hello-sh → hello-sh-flake

`diff -u examples/01-hello-sh/default.nix examples/03-hello-sh-flake/default.nix`:

```diff
--- examples/01-hello-sh/default.nix        2026-11-06 17:28:21.857035780 +0000
+++ examples/03-hello-sh-flake/default.nix  2026-11-06 19:02:49.360454863 +0000
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

## hello-flake → hello-sh-flake

`diff -u examples/02-hello-flake/flake.nix examples/03-hello-sh-flake/flake.nix`:
```diff
--- examples/02-hello-flake/flake.nix       2026-11-07 07:53:30.900152398 +0000
+++ examples/03-hello-sh-flake/flake.nix    2026-11-07 07:53:53.732442483 +0000
@@ -5,7 +5,7 @@

   outputs = inputs: {
     packages = builtins.mapAttrs (system: pkgs: {
-      hello = pkgs.hello;
+      hello = import ./default.nix { inherit pkgs; };

       default = inputs.self.packages.${system}.hello;
     }) inputs.nixpkgs.legacyPackages;
```

## Build

```
$ nix build
$ ./result/bin/hello.sh
hello world

$ nix build --no-link --print-out-paths
/nix/store/5hx1gk1dipib3spw0rb916lh07jra5n1-hello.sh
```

`nix build` is silent on success; `--print-out-paths` is the idiomatic way to get
the path without a `result` symlink.
