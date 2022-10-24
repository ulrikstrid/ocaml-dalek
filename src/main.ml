open Binding

let with_opaques f =
  f (); Gc.full_major ()

let with_arena f =
  let open Alien_ffi in
  let arena = Arena.alloc () in
  f arena;
  Arena.free arena

let with_full f =
  with_opaques (fun () -> with_arena (fun arena -> f arena))

let () =
  let message : Bigstring.t = Bigstring.of_string "a message" in
  with_opaques (fun () ->
      for _ = 0 to 1000 do
        let keypair = Keypair.generate () in
        let public = Keypair.public keypair in
        let signature = Keypair.sign keypair message in
        assert (PublicKey.verify public message signature);
      done;
      Printf.printf "generated 1000 keypairs";
      ()
    )
