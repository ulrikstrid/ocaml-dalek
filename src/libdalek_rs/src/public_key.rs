use alien_ffi::CustomOperations;
use alien_ffi::finalize;
use alien_ffi::{default_compare, default_compare_ext, default_hash};
use alien_ffi::{default_serialize, default_deserialize};

use ed25519_dalek::PublicKey;

// Version strings
static PUBLIC_KEY_ID: &'static [u8] = b"dalek.public_key\n\0";

// Exports
pub static PUBLIC_KEY_OPS: CustomOperations = CustomOperations {
    identifier: PUBLIC_KEY_ID.as_ptr() as *const i8,
    finalize: finalize::<PublicKey>,
    compare: default_compare,
    compare_ext: default_compare_ext,
    hash: default_hash,
    serialize: default_serialize,
    deserialize: default_deserialize,
};
