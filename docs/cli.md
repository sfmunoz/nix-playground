# Legacy commands vs new commands

`nix-build` and `nix build` are **not** the same command: the first is the legacy
CLI (takes a path or expression, impure by default), the second belongs to
`nix-command` and takes a **flake reference**, evaluated purely. This repository
uses the legacy entry points, so `nix build hello-c` fails — `hello-c` looks like
a flake reference:

```
$ nix build hello-c
error: cannot find flake 'flake:hello-c' in the flake registries

$ nix build --file examples/05-hello-c --no-link --print-out-paths
/nix/store/zwwr4ba28ahxx1x2fzp7ybb5p557817i-hello-c
```

`--file` is the escape hatch that makes the new CLI behave like `nix-build` on a
plain `default.nix`. Migration map:

| Legacy | New | Note |
|---|---|---|
| `nix-build` | `nix build` | flake reference instead of a path |
| `nix-instantiate` | `nix eval` / `nix build --dry-run` | `nix derivation show` for the `.drv` |
| `nix-shell` | `nix develop` | `nix develop` wants a flake |
| `nix-shell -p pkg` | `nix shell nixpkgs#pkg` | ad-hoc environment |
| `nix-env -iA nixpkgs.foo` | `nix profile install nixpkgs#foo` | profiles, not environments |
| `nix-env -q` | `nix profile list` | |
| `nix-env -e foo` | `nix profile remove foo` | |
| `nix-channel --update` | `nix flake update` | channels are the impure pinning mechanism |
| `nix-store -q --references` | `nix path-info --json ./result` | the `references` field: **direct** deps only |
| `nix-store -q --requisites` (`-R`) | `nix path-info -r` | full **closure**, not direct refs |
| `nix-collect-garbage` | `nix store gc` | |
| `nix-copy-closure` | `nix copy` | |
| `nix-hash` | `nix hash` | |
| `nix-prefetch-url` | `nix store prefetch-file` | |
