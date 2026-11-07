# hello-flake

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
