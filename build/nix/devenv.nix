{
  outputs = { nixpkgs, ... }: {
    packages = nixpkgs.lib.mapAttrs (_: pkgs: {
      default = pkgs.buildEnv {
        name = "dev";
        paths = with pkgs; [
          # ...
        ];
      };
    }) nixpkgs.legacyPackages;
  };
}
