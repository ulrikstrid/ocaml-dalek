{ pkgs ? import <nixpkgs>, alien_ffi, ... }:
{
  libdalek_rs = pkgs.rustPlatform.buildRustPackage {
    pname = "libdalek_rs";
    version = "0.0.1";
    src = ./.;
    cargoBuildFlags = "-p libdalek_rs";

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "libalien_ffi_rs-0.1.0" = "sha256-1iex89DGpb1FhUIQ1p3Vubsr1G/drk89Y0VNq7/theI=";
      };
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
