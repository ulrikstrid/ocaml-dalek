use alien_ffi::CustomOperations;
use alien_ffi::finalize;
use alien_ffi::{default_compare, default_compare_ext, default_hash};
use alien_ffi::{default_serialize, default_deserialize};

use ed25519_dalek::Signature;

// Version strings
static SIGNATURE_ID: &'static [u8] = b"dalek.signature\n\0";

// Exports
pub static SIGNATURE_OPS: CustomOperations = CustomOperations {
    identifier: SIGNATURE_ID.as_ptr() as *const i8,
    finalize: finalize::<Signature>,
    compare: default_compare,
    compare_ext: default_compare_ext,
    hash: default_hash,
    serialize: default_serialize,
    deserialize: default_deserialize,
};
