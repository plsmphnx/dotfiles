{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    clecompt.url = "github:plsmphnx/nixcfg";
  };
  outputs = { nixpkgs, nixos-hardware, clecompt, ... } @ inputs: {
    nixosConfigurations.system-name = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        clecompt.nixosModules.core
        nixos-hardware.nixosModules.hardware-module
        ./local.nix
      ];
    };
  };
}
