{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    clecompt = {
      url = "github:plsmphnx/nixcfg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, nixos-hardware, clecompt, ... } @ inputs: {
    nixosConfigurations.system-name = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        user = "clecompt";
        host = "system-name";
      };
      modules = [
        ./hardware-configuration.nix
        nixos-hardware.nixosModules.hardware-module
        clecompt.nixosModules.core
        clecompt.nixosModules.login
        ./local.nix
      ];
    };
  };
}
