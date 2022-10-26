{ pkgs ? import <nixpkgs>, alien_ffi, ... }:
{
  libdalek_rs = pkgs.rustPlatform.buildRustPackage {
    pname = "libdalek_rs";
    version = "0.0.1";
    src = ./src/libdalek_rs/.;
    cargoBuildFlags = "-p libdalek_rs";

    cargoLock = {
      lockFile = ./src/libdalek_rs/Cargo.lock;
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
  };

  ocaml-dalek = pkgs.ocaml-ng.ocamlPackages_5_0.buildDunePackage rec {
    pname = "ocaml_dalek";
    version = "0.0.1-dev";
    src = ./src/.;

    buildInputs = [
      alien_ffi.outputs.packages.x86_64-linux.libalien_ffi_c
      alien_ffi.outputs.packages.x86_64-linux.libalien_ffi_rs
      alien_ffi.outputs.packages.x86_64-linux.alien_ffi
      pkgs.ocaml-ng.ocamlPackages_5_0.bigstring
    ];

    buildPhase = ''
      runHook preBuild
      dune build -p ${pname}
      runHook postBuild
    '';

    isLibrary = true;

  };
}
