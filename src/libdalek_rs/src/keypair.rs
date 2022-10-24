use alien_ffi::CustomOperations;
use alien_ffi::finalize;
use alien_ffi::{default_compare, default_compare_ext, default_hash};
use alien_ffi::{default_serialize, default_deserialize};

use ed25519_dalek::Keypair;

// Version strings
static KEYPAIR_ID: &'static [u8] = b"dalek.keypair\n\0";

// Exports
pub static KEYPAIR_OPS: CustomOperations = CustomOperations {
    identifier: KEYPAIR_ID.as_ptr() as *const i8,
    finalize: finalize::<Keypair>,
    compare: default_compare,
    compare_ext: default_compare_ext,
    hash: default_hash,
    serialize: default_serialize,
    deserialize: default_deserialize,
};
