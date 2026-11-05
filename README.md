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
