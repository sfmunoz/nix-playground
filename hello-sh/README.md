# hello-sh

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
