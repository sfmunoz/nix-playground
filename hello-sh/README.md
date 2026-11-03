# hello-sh

## Build example

Build:
```
$ nix-build
this derivation will be built:
  /nix/store/smq81bji0ffplp6bx9vb8p4pkhgfidkl-hello.sh.drv
building '/nix/store/smq81bji0ffplp6bx9vb8p4pkhgfidkl-hello.sh.drv'...
/nix/store/b97vp7x63hfa06vlxnx01cdiy9fpda57-hello.sh
```
Output:
```
$ ls -l result
lrwxrwxrwx 1 i12e users 52 Nov  3 17:31 result -> /nix/store/b97vp7x63hfa06vlxnx01cdiy9fpda57-hello.sh
```
```
$ cat result
hello
```

## nix profile vs nix-env

### nix profile (new way)

Hard reset:
```
$ rm -rf ~/.nix-profile ~/.local/state/nix
```
Install:
```
$ nix profile add --file default.nix

$ nix profile list
Name:               hello.sh
Store paths:        /nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh
```

### nix-env (old way)

Hard reset:
```
$ rm -rf ~/.nix-profile ~/.local/state/nix
```
Install:
```
$ nix-env --install --file default.nix

$ nix-env -q
hello.sh
```
Without the "hard reset":
```
$ nix-env --install --file default.nix
error: profile "/home/i12e/.local/state/nix/profiles/profile" is incompatible with 'nix-env'; please use 'nix profile' instead
```
