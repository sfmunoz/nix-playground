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

## Tips

### The simplest derivation

https://nixos.org/guides/nix-pills/18-nix-store-paths.html

...the simplest derivation you can write has a name, a builder and the system:

```
$ nix repl
nix-repl> derivation { system = "x86_64-linux"; builder = ./myfile; name = "foo"; }
«derivation /nix/store/y4h73bmrc9ii5bxg6i7ck6hsf5gqv8ck-foo.drv»
```

### Nix compile

Build:
```
$ nix-build hello-sh
/nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh
```

Equivalent, in two steps: evaluate to a `.drv`, then realise it.
```
$ nix-instantiate hello-sh
/nix/store/iwyd1b3880yy1ppik8wnb1z5w4lasqgr-hello.sh.drv

$ nix-store -r /nix/store/iwyd1b3880yy1ppik8wnb1z5w4lasqgr-hello.sh.drv
/nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh
```

`nix-build` also leaves the `result` symlink and roots it against GC; `nix-store -r`
needs `--add-root` for that.

### Derivations: C analogy

https://nixos.org/guides/nix-pills/06-our-first-derivation.html

- `.nix` files are like `.c` files.
- `.drv` files are intermediate files like `.o` files.
  - The `.drv` describes how to build a derivation
  - It’s the bare minimum information.
- Out paths are then the product of the build.

### Nix derivation show

https://nixos.org/guides/nix-pills/06-our-first-derivation.html

```
$ nix derivation show /nix/store/iwyd1b3880yy1ppik8wnb1z5w4lasqgr-hello.sh.drv
{
  "derivations": {
    (...)
  },
  "version": 4
}
```

### Full content of a derivation

`:p` collapses any attribute set whose `type` is `"derivation"`, so dropping that
attribute shows the whole value:

```
$ nix repl
nix-repl> d = derivation { name = "myname"; builder = "mybuilder"; system = "mysystem"; }

nix-repl> :p d
«derivation /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv»

nix-repl> :p builtins.removeAttrs d [ "type" ]
{
  all = [
    «derivation /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv»
  ];
  builder = "mybuilder";
  drvAttrs = {
    builder = "mybuilder";
    name = "myname";
    system = "mysystem";
  };
  drvPath = "/nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv";
  name = "myname";
  out = «repeated»;
  outPath = "/nix/store/40s0qmrfb45vlh6610rk29ym318dswdr-myname";
  outputName = "out";
  system = "mysystem";
}
```

`drvAttrs` holds the inputs only; `nix derivation show d.drvPath` shows the stored
`.drv` instead, including `env` and `inputs`.

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
| `nix-store -q --references` | `nix path-info -r` | |
| `nix-collect-garbage` | `nix store gc` | |
| `nix-copy-closure` | `nix copy` | |
| `nix-hash` | `nix hash` | |
| `nix-prefetch-url` | `nix store prefetch-file` | |
