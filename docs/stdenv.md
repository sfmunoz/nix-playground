# stdenv

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
