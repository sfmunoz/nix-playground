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

## Build

```
$ nix build .#hello
$ ./result/bin/hello
Hello, world!
```

`nix build` (or `nix build .`) resolves through the `default` attribute to the same
package; `--no-link --print-out-paths` prints the store path without a symlink.

## Run

```
$ nix run .#hello
Hello, world!
```

This flake re-exports `pkgs.hello` unchanged — it defines no derivation of its own.
