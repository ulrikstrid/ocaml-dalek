{
  description = "A flake for building `ocaml-dalek`";

  # Use existing `deku` cache for faster resolution of dependencies.
  nixConfig = {
    extra-substituters = "https://ocaml.nix-cache.com";
    extra-trusted-public-keys = "ocaml.nix-cache.com-1:/xI2h2+56rwFfKyyFVbkJSeGqSIYMC/Je+7XXqGKDIY=";
  };

  # Use the same `nixpkgs` as `deku` for `OCaml5`.
  inputs.nixpkgs.url = github:nix-ocaml/nix-overlays;
  # Use the same `rust-overlay` as `ZeroFX`.
  inputs.rust-overlay.url = github:oxalica/rust-overlay;
  inputs.flake-utils.follows = "rust-overlay/flake-utils";
  inputs.alien_ffi.url = github:zfxlabs/alien_ffi;

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        code = pkgs.callPackage ./. {
          inherit nixpkgs system rust-overlay;
          inherit (alien_ffi.packages.${system}) libalien_ffi_c libalien_ffi_rs;
          alien_ffi = alien_ffi.packages.${system}.alien_ffi;
        };
      in rec {
        packages = {
          libdalek_rs = code.libdalek_rs;
          ocaml-dalek = code.ocaml_dalek;
          all = pkgs.symlinkJoin {
            name = "all";
            paths = with code; [ (ocaml-dalek pkgs.ocaml-ng.ocamlPackages_5_0) libdalek_rs ];
          };
          default = packages.all;
        };
      }
    );
}
