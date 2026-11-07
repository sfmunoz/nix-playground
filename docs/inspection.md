# Inspecting source code

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
