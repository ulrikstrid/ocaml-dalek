open Ocaml_dalek.Binding
open Alien_ffi.Interface
open Alien_ffi.Bench

let () =
  let items = 1000 in
  let prepare () =
    let keypair = Keypair.generate () in
    let public = Keypair.public keypair in
    let items =
      List.init items (fun _n ->
          let message : Bigstring.t = Bigstring.of_string "a message" in
          let signature = Keypair.sign keypair message in
          (message, signature)
        )
    in
    (public, items)
  in
  with_opaques (fun () ->
      bench "verify" ~items ~prepare (fun (public, items) ->
          let _units : unit list =
            List.map
              (fun (message, signature) ->
                assert (PublicKey.verify public message signature)
              ) items
          in
          ()
    ))

let () =
  let items = 1 in
  let n_batch_items = 1000 in
  let prepare () =
    let keypair = Keypair.generate () in
    let public = Keypair.public keypair in
    let items =
      List.init items (fun n ->
          let batch = Batch.allocate () in
          let message : Bigstring.t = Bigstring.of_string "a message" in
          let signature = Keypair.sign keypair message in
          for _ = 0 to n_batch_items do
            let () = Batch.push_message batch message in
            let () = Batch.push_signature batch signature in
            let () = Batch.push_public_key batch public in
            ()
          done;
          (batch, n)
        )
    in
    items
  in
  with_opaques (fun () ->
      bench "verify_batch" ~items ~prepare (fun items ->
          let _units : unit list =
            List.map
              (fun (batch, _) ->
                assert (verify_batch batch)
              ) items
          in
          ()
    ))
