{
  description = "hello.sh, flake way";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      hello-sh = import ./default.nix { inherit pkgs; };

      default = inputs.self.packages.${system}.hello-sh;
    }) inputs.nixpkgs.legacyPackages;
  };
}
