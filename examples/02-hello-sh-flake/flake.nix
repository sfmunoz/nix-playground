{
  description = "hello";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      hello = import ./default.nix { inherit pkgs; };

      default = inputs.self.packages.${system}.hello;
    }) inputs.nixpkgs.legacyPackages;
  };
}
