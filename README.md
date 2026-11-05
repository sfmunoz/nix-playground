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

## Examples

- [hello-sh](hello-sh/README.md)

## Tips

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

### Realise a Nix derivation

https://nixos.org/guides/nix-pills/06-our-first-derivation.html

```
$ nix-store -r /nix/store/z3hhlxbckx4g3n9sw91nnvlkjvyw754p-myname.drv
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
