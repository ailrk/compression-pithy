{
  description = "pithy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskell.packages.ghc922;
        packageName = "pithy";
      in {
        packages =  {
          ${packageName} = haskellPackages.callCabal2nix packageName self rec { };

          default = self.packages.${system}.${packageName};
        };

        devShell = pkgs.mkShell {
          buildInputs = with haskellPackages; [
            haskell-language-server
            fourmolu
            ghcid
            cabal-install
            ghc
          ];
          inputFrom = builtins.attrValues self.packages.${system};
        };
      });
}
