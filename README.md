# nix-playground

[Nix](https://nix.dev/) + [NixOS](https://nixos.org/) playground repository.

## References

- [Nix](https://nix.dev/)
- [NixOS](https://nixos.org/) → [NixOS Learn](https://nixos.org/learn/) → **[Nix Pills](https://nixos.org/guides/nix-pills/)**
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
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
- Nixpkgs
  - [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs)
  - [sfmunoz/nixpkgs](https://github.com/sfmunoz/nixpkgs)

## Examples

A single artifact, three packaging styles:

- [01-hello-sh](examples/01-hello-sh/README.md) — the simplest derivation: bare `derivation`, `import <nixpkgs>`, legacy `nix-build`.
- [02-hello-flake](examples/02-hello-flake/README.md) — no derivation at all: re-export `pkgs.hello` from a flake.
- [03-hello-sh-flake](examples/03-hello-sh-flake/README.md) — same derivation as 01, packaged the flake way (`pkgs` passed in).

Under the hood (Nix Pills):

- [04-builder-sh](examples/04-builder-sh/README.md) — Pills ch. 7: derivation attributes as build-environment variables, the sandbox.
- [05-hello-c](examples/05-hello-c/README.md) — Pills ch. 8: a real compiler, the `src` attribute, `let` vs derivation attributes.

## Topics

- [Derivations](docs/derivations.md) — `.nix` → `.drv` → out path: `nix-build` vs
  `nix-instantiate` + `nix-store -r`, `nix derivation show`, and the full shape of a
  derivation value.
- [stdenv](docs/stdenv.md) — not magic: the generic builder as an inspectable shell
  script, its phases and its direct store references.
- [lib](docs/lib.md) — the nixpkgs standard library in `nix repl`, plus `:doc` and
  `builtins.functionArgs` introspection.
- [Inspecting source code](docs/inspection.md) — `:p` on a lambda gives you the store
  path and line; builtins live inside the binary.
- [Profiles: `nix profile` vs `nix-env`](docs/profiles.md) — one profile path, two
  manifest formats, and how to move between them.
- [Legacy commands vs new commands](docs/cli.md) — `nix-build` vs `nix build`, and a
  14-row migration table.
