{
  description = "compress-pity";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        jailbreakUnbreak = pkg: pkgs.haskell.lib.doJailbreak (pkg.overrideAttrs (_ : { meta = {}; }));
        haskellPackages = pkgs.haskell.packages.ghc922.override {
          overrides = self: super: rec { };
         };
        gitVersion = if (self ? shortRev) then self.shortRev else "dirty";

        mkDevShell = packagesInShell: haskellPackages.shellFor {
            packages = pkgs: packagesInShell ;
            buildInputs = with haskellPackages;
              [
                fourmolu
                hspec-discover
                haskell-language-server
              ];
            LD_LIBRARY_PATH = [ "${pkgs.zlib}/lib" ];
            doCheck = false;
          };

      in {
        packages = {
          compress-pity = pkgs.haskell.lib.justStaticExecutables (haskellPackages.callCabal2nix "compress-pity" ./. { });
          default = self.packages.${system}.compress-pity;
        };

        devShells = {
          default = mkDevShell [ self.packages.${system}.compress-pity ];
        };

        devShell = self.devShells.${system}.default;
        defaultPackage = self.packages.${system}.default;
      });
}
