# lib

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
