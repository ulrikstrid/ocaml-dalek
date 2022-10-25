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

let bench f =
  let t1 = Unix.gettimeofday () in
  let () = f () in
  let t2 = Unix.gettimeofday () in
  t2 -. t1

let bench msg ~items ~prepare run =
  let runs = 10 in
  let value = prepare () in
  let results =
    List.init runs (fun n ->
        let time = bench (fun () -> run value) in
        Format.eprintf "%s(%d): %.3f\n%!" msg n time;
        time)
  in
  let total = List.fold_left (fun acc time -> acc +. time) 0.0 results in
  let average = total /. Int.to_float runs in
  let per_second = Int.to_float items /. average in
  Format.eprintf "%s: %.3f\n%!" msg average;
  Format.eprintf "%s: %.3f/s\n%!" msg per_second

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
