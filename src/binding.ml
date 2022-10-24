
module Signature = struct
  type t
end

module PublicKey = struct
  type t

  external verify : t -> Bigstring.t -> Signature.t -> bool = "public_key_verify"
end

module Keypair = struct
  type t

  external generate : unit -> t = "generate_keypair"

  external sign : t -> Bigstring.t -> Signature.t = "keypair_sign"

  external public : t -> PublicKey.t = "keypair_public"
end

module Batch = struct
  type t

  external allocate : unit -> t = "allocate_batch"

  external push_message : t -> Bigstring.t -> unit = "push_message"

  external push_signature : t -> Signature.t -> unit = "push_signature"

  external push_public_key : t -> PublicKey.t -> unit = "push_public_key"
end

external verify_batch : Batch.t -> bool
