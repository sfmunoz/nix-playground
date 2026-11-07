# Derivations

From a `.nix` file to a `.drv` to a store path.

## The simplest derivation: name + builder + system

https://nixos.org/guides/nix-pills/18-nix-store-paths.html

...the simplest derivation you can write has a name, a builder and the system:

```
$ nix repl
nix-repl> derivation { system = "x86_64-linux"; builder = ./myfile; name = "foo"; }
«derivation /nix/store/y4h73bmrc9ii5bxg6i7ck6hsf5gqv8ck-foo.drv»
```

## Derivations: C analogy

https://nixos.org/guides/nix-pills/06-our-first-derivation.html

- `.nix` files are like `.c` files.
- `.drv` files are intermediate files like `.o` files.
  - The `.drv` describes how to build a derivation
  - It’s the bare minimum information.
- Out paths are then the product of the build.

## Nix compile

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

## Nix derivation show

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

## Full content of a derivation

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
