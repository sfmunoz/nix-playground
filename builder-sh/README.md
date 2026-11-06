# builder-sh

## Reference

https://nixos.org/guides/nix-pills/07-working-derivation.html

## Build

```
$ nix-build
/nix/store/srnlxpv3rsigqan4lr397awj4yj1nwgx-builder-sh
```

## Read the build log

`builder.sh` runs `declare -xp`, so the exported environment lands in the log of
that output path:

```
$ nix-store --read-log /nix/store/srnlxpv3rsigqan4lr397awj4yj1nwgx-builder-sh
declare -x HOME="/homeless-shelter"
declare -x NIX_BUILD_CORES="4"
declare -x NIX_BUILD_TOP="/build"
declare -x PATH="/path-not-set"
declare -x PWD="/build"
declare -x TEMP="/build"
declare -x TMPDIR="/build"
declare -x builder="/nix/store/13czpvp88x852739v5xi04s871pn35b5-bash-interactive-5.3p9/bin/bash"
declare -x name="builder-sh"
declare -x out="/nix/store/srnlxpv3rsigqan4lr397awj4yj1nwgx-builder-sh"
declare -x system="x86_64-linux"
```

Same command as the Nix Pills example:

```
$ nix-store --read-log /nix/store/gczb4qrag22harvv693wwnflqy7lx5pb-foo
```

The sandbox explains the odd values: `HOME=/homeless-shelter`, `PATH=/path-not-set`
and an empty `/build` are deliberate, so builders cannot depend on the host.
