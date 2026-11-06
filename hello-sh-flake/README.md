# hello-sh-flake

Same output as [hello-sh](../hello-sh/README.md), packaged the flake way.

## Layout

- `default.nix` — the derivation, as a **function of `pkgs`**: `{ pkgs }: …`
- `flake.nix` — pins nixpkgs, instantiates `pkgs` per system, imports `default.nix`
- `flake.lock` — the actual pin (`rev` + `narHash`)

`default.nix` no longer imports `<nixpkgs>`; it receives `pkgs` already built for a
concrete system. That is what makes pure evaluation possible: the file has no
ambient inputs left.

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

## The flake

```nix
outputs = inputs: {
  packages = builtins.mapAttrs (system: pkgs: {
    hello-sh = import ./default.nix { inherit pkgs; };

    default = inputs.self.packages.${system}.hello-sh;
  }) inputs.nixpkgs.legacyPackages;
};
```

- `legacyPackages` is keyed by system, so `mapAttrs` builds one package per system
  (10 on this nixpkgs) without any `systems = [ … ]` list and without `flake-utils`.
- `default` makes `nix build .#` resolve to the package.
- `system = pkgs.stdenv.hostPlatform.system;` inside the derivation — `builtins.currentSystem`
  cannot be used under pure evaluation.
- `pkgs.system` still works but warns:
  `'system' has been renamed to/replaced by 'stdenv.hostPlatform.system'`.

## Why the store path differs from `hello-sh`

| | `hello-sh` | `hello-sh-flake` |
|---|---|---|
| nixpkgs | `<nixpkgs>` from `NIX_PATH` (registry) | locked tarball, rev `6dadaf4` |
| bash | `bash-interactive-5.3p9` | `bash-interactive-5.3p20` |
| output | `0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh` | `5hx1gk1dipib3spw0rb916lh07jra5n1-hello.sh` |

Same script, same behaviour, different dependency closure — an unpinned channel
versus a pinned revision. The legacy build also prints:

```
warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels' does not exist, ignoring
```

That warning is a `NIX_PATH` lookup. The flake build never reads `NIX_PATH`, so it
does not appear.

## Flake reference, not a directory

```
$ nix build hello-sh-flake
error: cannot find flake 'flake:hello-sh-flake' in the flake registries
```

Run from this directory (`nix build .#hello-sh`), or point at it explicitly from
the repository root:

```
$ nix build ./hello-sh-flake#hello-sh
/nix/store/5hx1gk1dipib3spw0rb916lh07jra5n1-hello.sh
```

## Caveats

- This is a **nested flake**: the flake root is the git repository, with
  `?dir=hello-sh-flake`. Only **git-tracked** files are visible; an untracked
  `default.nix` change builds the old version.
- The input is a channel URL, so `nix flake update` moves it. Pin `rev=` to freeze.
- `nix flake show` evaluates all 10 systems and is slow; non-native systems are
  shown as `omitted` unless `--all-systems` is passed.
