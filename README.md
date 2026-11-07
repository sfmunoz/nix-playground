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
- Nixpkgs
  - [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs)
  - [sfmunoz/nixpkgs](https://github.com/sfmunoz/nixpkgs)

## Examples

- [hello-sh](hello-sh/README.md)
- [hello-sh-flake](hello-sh-flake/README.md)
- [builder-sh](builder-sh/README.md)
- [hello-c](hello-c/README.md)
- [hello-flake](hello-flake/README.md)

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
