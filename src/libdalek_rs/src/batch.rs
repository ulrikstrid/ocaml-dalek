use alien_ffi::CustomOperations;
use alien_ffi::finalize;
use alien_ffi::{default_compare, default_compare_ext, default_hash};
use alien_ffi::{default_serialize, default_deserialize};

use crate::Batch;

// Version strings
static BATCH_ID: &'static [u8] = b"dalek.batch\n\0";

// Exports
pub static BATCH_OPS: CustomOperations = CustomOperations {
    identifier: BATCH_ID.as_ptr() as *const i8,
    finalize: finalize::<Batch>,
    compare: default_compare,
    compare_ext: default_compare_ext,
    hash: default_hash,
    serialize: default_serialize,
    deserialize: default_deserialize,
};
