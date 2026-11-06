# hello-c

## Reference

https://nixos.org/guides/nix-pills/08-generic-builders.html

## Build

```
$ nix-build hello-c
/nix/store/zwwr4ba28ahxx1x2fzp7ybb5p557817i-hello-c
```

`result` is a symlink in the **current** directory, not in `hello-c`:

```
$ ./result/hello-c
hello world!
```

## Why `builder.sh` needs those attributes

`builder.sh` reads `$coreutils` and `$gcc`, so both must be attributes of the
derivation:

```nix
inherit (pkgs) coreutils gcc;
```

Derivation attributes become environment variables for the builder; `let`
bindings do not. `bash` is not an attribute because it is only interpolated into
`builder`. Without the two `inherit`s the build fails (log excerpt):

```
+ export PATH=/bin:/bin
(...)
line 3: mkdir: command not found
(...)
line 4: gcc: command not found
error: builder failed with exit code 127
```
