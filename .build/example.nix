{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    clecompt = {
      url = "github:plsmphnx/nixcfg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: {
    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        inputs.clecompt.nixosModules.core
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ./configuration.nix
      ];
    };
  };
}
