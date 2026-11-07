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

## nix profile vs nix-env

Both tools install into the same profile path,
`~/.local/state/nix/profiles/profile`, but with different formats:

- `nix profile` (new CLI) writes `manifest.json`.
- `nix-env` (legacy) writes `manifest.nix`.

A profile in one format cannot be used by the other tool.

### Converting to the legacy format

The default profile is created by whichever tool runs first. To hand it to
`nix-env`, remove the new-style profile and its generations:

```
$ rm -rf ~/.local/state/nix/profiles/profile ~/.local/state/nix/profiles/profile-*
$ rm -f  ~/.nix-profile
```

Removing only the `~/.nix-profile` symlink is **not** enough: `nix-env` recreates
it pointing at the same profile directory and still finds `manifest.json`.

Caveat: this discards the list of packages the new-style profile held; they stay
in the store but are no longer "installed".

### Alternative: give `nix-env` its own profile

Keeping the default profile untouched avoids the conversion altogether:

```
$ mkdir -p ~/profiles
$ nix-env --install --file default.nix --profile ~/profiles/legacy

$ ~/profiles/legacy/bin/hello.sh
hello world

$ nix-env --profile ~/profiles/legacy -q
hello.sh
```

The profile is then independent: `nix profile` keeps managing the default one.
The parent directory must exist, otherwise:
```
$ nix-env --install --file default.nix --profile ~/profiles/legacy
error: opening lock file "/home/i12e/profiles/legacy.lock": No such file or directory
```

### nix profile (new way)

Install:
```
$ nix profile add --file default.nix

$ nix profile list
Name:               hello.sh
Store paths:        /nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh
```

### nix-env (old way)

Install:
```
$ nix-env --install --file default.nix

$ nix-env -q
hello.sh
```

Without converting the profile first:
```
$ nix-env --install --file default.nix
error: profile "/home/i12e/.local/state/nix/profiles/profile" is incompatible with 'nix-env'; please use 'nix profile' instead
```
