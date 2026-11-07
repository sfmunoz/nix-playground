# hello-flake

## hello-flake → hello-sh-flake

**diff -u hello-flake hello-sh-flake**:

```diff
Only in hello-sh-flake: default.nix
diff --color -u hello-flake/flake.nix hello-sh-flake/flake.nix
--- hello-flake/flake.nix       2026-11-07 07:53:30.900152398 +0000
+++ hello-sh-flake/flake.nix    2026-11-07 07:53:53.732442483 +0000
@@ -5,7 +5,7 @@

   outputs = inputs: {
     packages = builtins.mapAttrs (system: pkgs: {
-      hello = pkgs.hello;
+      hello = import ./default.nix { inherit pkgs; };

       default = inputs.self.packages.${system}.hello;
     }) inputs.nixpkgs.legacyPackages;
Only in hello-sh-flake: README.md
Common subdirectories: hello-flake/result and hello-sh-flake/result
```
