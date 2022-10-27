{ pkgs ? import <nixpkgs>, alien_ffi, libalien_ffi_c, libalien_ffi_rs, ... }:
rec {
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

  ocaml-dalek = ocamlPackages: with ocamlPackages; buildDunePackage rec {
    pname = "ocaml_dalek";
    version = "0.0.1-dev";
    src = ./src/.;

    propagatedBuildInputs = [
      libalien_ffi_c
      libalien_ffi_rs
      libdalek_rs
      (alien_ffi ocamlPackages)
      bigstring
    ];

    buildPhase = ''
      runHook preBuild
      dune build -p ${pname}
      runHook postBuild
    '';
  };
}
