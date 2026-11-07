# nix-playground

[Nix](https://nix.dev/) + [NixOS](https://nixos.org/) playground repository.

## References

- [Nix](https://nix.dev/)
- [NixOS](https://nixos.org/) → [NixOS Learn](https://nixos.org/learn/) → **[Nix Pills](https://nixos.org/guides/nix-pills/)**
- [Nix is Simpler Than You Think | Derivations & Packages](https://www.youtube.com/watch?v=GBTTVrmqkfE)
  - Derivations
  - Packages
  - Builders
  - Overrides
- [Nix Functions Explained | NixOS & Flakes Functions](https://www.youtube.com/watch?v=HiTgbsFlPzs)
- [🧙 Master Nix Functions in 20 Minutes | From Basics to Real-World Examples](https://www.youtube.com/watch?v=gn5wc531LD8)
- [Nix derivations: what your Nix file becomes, input hashes and the build sandbox](https://www.youtube.com/watch?v=K7MkLa2HnIk)
- Cheatsheet
  - [Nixcademy](https://nixcademy.com/downloads/cheatsheet.pdf) (PDF)
  - [Cheat Sheets](https://cheatsheets.zip/nix)

## Examples

- [hello-sh](hello-sh/README.md)
- [hello-sh-flake](hello-sh-flake/README.md)
- [builder-sh](builder-sh/README.md)
- [hello-c](hello-c/README.md)
- [hello-flake](hello-flake/README.md)

## Topics

- [Derivations](docs/derivations.md) — `.nix` → `.drv` → out path: `nix-build` vs
  `nix-instantiate` + `nix-store -r`, `nix derivation show`, and the full shape of a
  derivation value.
- [Profiles: `nix profile` vs `nix-env`](docs/profiles.md) — one profile path, two
  manifest formats, and how to move between them.

## Tips

### stdenv

https://nixos.org/guides/nix-pills/19-fundamentals-of-stdenv.html

`stdenv` is not magic, it is a library: its whole build logic is a plain shell
script shipped in the output. Inspect it instead of guessing.

```
$ nix-build '<nixpkgs>' -A stdenv
/nix/store/bds9i60lxg8viivxw59b9l18hl8h1vcd-stdenv-linux

$ nix build nixpkgs#stdenv --no-link --print-out-paths
/nix/store/bds9i60lxg8viivxw59b9l18hl8h1vcd-stdenv-linux
```

`result/setup` (1841 lines) is the generic builder: it defines the phases that
`runPhase` drives, puts the phases' tools on `PATH` via `initialPath`, and sets
`defaultNativeBuildInputs` — the hooks every package inherits.

```
$ vi result/setup
$ grep -n '^[a-zA-Z]*Phase()' result/setup
1304:unpackPhase() {
1378:patchPhase() {
1430:configurePhase() {
1513:buildPhase() {
1537:checkPhase() {
1577:installPhase() {
1612:fixupPhase() {
1664:installCheckPhase() {
1693:distPhase() {
1745:runPhase() {
```

`result` only keeps the *direct* references, i.e. the tools those scripts call by
store path (31 of them):

```
$ nix-store -q --references result
/nix/store/hc49zakwkkyp9zlyl80b71jhxkpn4hsx-bash-5.3p9
/nix/store/kwc34h21my8mf7xbqm9gxs1xfx07xb4i-coreutils-9.11
… 29 more
```

### lib

`lib` is the nixpkgs standard library: pure Nix helpers (lists, attrsets, strings,
modules), no derivations, no `system`. It is just one attribute of the nixpkgs set,
so it becomes available once that set is in scope:

```
$ nix repl
nix-repl> :l <nixpkgs>
Added 27261 variables.
```

```
nix-repl> lib.concatStringsSep "," (lib.map toString [ 1 2 3 ])
"1,2,3"

nix-repl> lib.genAttrs [ "a" "b" ] (n: n)
{ a = "a"; b = "b"; }

nix-repl> lib.optional true "yes"
[ "yes" ]
```

Bare `nix repl` has no `lib` in scope (`error: undefined variable 'lib'`); the
flake entry point loads it directly:

```
$ nix repl nixpkgs
nix-repl> lib.version
"26.05.19700101.dirty"
```

Introspect instead of guessing — `:doc` prints the docstring, `builtins.functionArgs`
the named arguments a function accepts:

```
nix-repl> :doc lib.concatStringsSep
Synopsis: builtins.concatStringsSep separator list

Concatenate a list of strings with a separator between each

nix-repl> builtins.functionArgs lib.genAttrs
{ }
```

### Inspecting source code

Nixpkgs functions live on disk: `:p` prints the real store path and line.

```
$ nix repl --file '<nixpkgs>'
nix-repl> :p lib.mkIf
«lambda mkIf @ /nix/store/42h7k7nz90k8hi5qd9mr2ijnfvbircz4-source/lib/modules.nix:1563:10»
```

Nix builtins are compiled into the binary, hence the `«nix-internal»` pseudo-path:

```
$ nix repl
nix-repl> :p builtins.derivation
«lambda @ «nix-internal»/derivation-internal.nix:30:1»

$ nix build --no-link --print-out-paths nixpkgs#nix.src
/nix/store/jmm4j1jgrcdsgvigsjgsnxg2iz5p1vvm-source
```

That source tree holds `src/libexpr/primops/derivation.nix`, a wrapper around the
`derivationStrict` primop implemented in `src/libexpr/primops.cc`.

Docs, without the source:

```
nix-repl> :doc builtins.derivation
nix-repl> builtins.functionArgs builtins.derivation
{ outputs = true; }
```

Online: [NixOS/nix](https://github.com/NixOS/nix) (same paths),
[noogle.dev](https://noogle.dev/) (nixpkgs search).

## Legacy commands vs new commands

`nix-build` and `nix build` are **not** the same command: the first is the legacy
CLI (takes a path or expression, impure by default), the second belongs to
`nix-command` and takes a **flake reference**, evaluated purely. This repository
uses the legacy entry points, so `nix build hello-c` fails — `hello-c` looks like
a flake reference:

```
$ nix build hello-c
error: cannot find flake 'flake:hello-c' in the flake registries

$ nix build --file hello-c --no-link --print-out-paths
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
