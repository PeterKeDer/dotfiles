{
  description = "Home manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      mkHomeConfiguration =
        hostInfo@{
          username,
          homeDirectory,
          repoDirectory,
          system,
          configuration ? { },
        }:
        let
          defaultConfiguration = {
            pkgs = import nixpkgs { inherit system; };
            modules = [ ./home.nix ];

            extraSpecialArgs = {
              unstable = import nixpkgs-unstable { inherit system; };
              inherit hostInfo;
            };
          };
          mergedConfiguration = lib.attrsets.recursiveUpdate defaultConfiguration configuration;
        in
        home-manager.lib.homeManagerConfiguration mergedConfiguration;

      hosts = map import [
        ./hosts/personal.nix
        ./hosts/work.nix
      ];

      # Create home configuration for each host indexed by username
      homeConfigurations = builtins.listToAttrs (
        (map (host: {
          name = host.username;
          value = mkHomeConfiguration host;
        }) hosts)
      );
    in
    {
      homeConfigurations = homeConfigurations;
    };
}
