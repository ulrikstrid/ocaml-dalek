extern crate rand;
extern crate alien_ffi;
extern crate ed25519_dalek;

mod keypair;
mod public_key;
mod signature;
mod batch;

use alien_ffi::caml_opaque;
use alien_ffi::{Value};
//use alien_ffi::{acquire_ba_arena, arena_alloc_ba};
use alien_ffi::{ops, caml_false, caml_true, caml_to_slice};
use rand::rngs::OsRng;

use ed25519_dalek::{Keypair, PublicKey, Signature};
use ed25519_dalek::{Signer, Verifier};

use keypair::KEYPAIR_OPS;
use public_key::PUBLIC_KEY_OPS;
use signature::SIGNATURE_OPS;
use batch::BATCH_OPS;

// Keypair
#[no_mangle]
pub extern fn generate_keypair(_unit: Value) -> Value {
    let mut csprng: OsRng = OsRng{};
    let keypair: Keypair = Keypair::generate(&mut csprng);
    caml_opaque::alloc::<Keypair>(ops(&KEYPAIR_OPS), keypair)
}

#[no_mangle]
pub extern fn keypair_sign(keypair: Value, message: Value) -> Value {
    let keypair = caml_opaque::acquire::<Keypair>(keypair);
    let data = caml_to_slice::<u8>(message);
    caml_opaque::alloc::<Signature>(ops(&SIGNATURE_OPS), keypair.sign(data))
}

#[no_mangle]
pub extern fn keypair_public(keypair: Value) -> Value {
    let keypair = caml_opaque::acquire::<Keypair>(keypair);
    caml_opaque::alloc::<PublicKey>(ops(&PUBLIC_KEY_OPS), keypair.public)
}

#[no_mangle]
pub extern fn public_key_verify(public_key: Value, message: Value, signature: Value) -> Value {
    let public_key = caml_opaque::acquire::<PublicKey>(public_key);
    let data = caml_to_slice::<u8>(message);
    let signature = caml_opaque::acquire::<Signature>(signature);
    if public_key.verify(data, signature).is_ok() {
	caml_true()
    } else {
	caml_false()
    }
}

pub struct Batch<'a> {
    messages: Vec<&'a[u8]>,
    signatures: Vec<Signature>,
    public_keys: Vec<PublicKey>,
}

// impl<'a> Batch<'a> {
//     pub fn new() -> Batch<'static> {
// 	Batch { messages: vec![], signatures: vec![], public_keys: vec![] }
//     }
//     pub fn push_message(&mut self, message: &[u8]) {
// 	self.messages.push(message)
//     }
//     pub fn push_signature(&mut self, signature: Signature) {
// 	self.signatures.push(signature)
//     }
//     pub fn push_public_key(&mut self, public_key: PublicKey) {
// 	self.public_keys.push(public_key)
//     }
// }

// #[no_mangle]
// pub extern fn allocate_batch(_unit: Value) -> Value {
//     caml_opaque::alloc::<Batch>(ops(&BATCH_OPS), Batch::new())
// }

// #[no_mangle]
// pub extern fn push_message(batch: Value, message: Value) {
//     let mut batch = caml_opaque::acquire::<Batch>(batch);
//     let message = caml_to_slice::<u8>(message);
//     batch.push_message(message)
// }

// #[no_mangle]
// pub extern fn push_signature(batch: Value, signature: Value) {
//     let mut batch = caml_opaque::acquire::<Batch>(batch);
//     let signature = caml_opaque::acquire::<Signature>(signature);
//     batch.push_signature(*signature)
// }

// #[no_mangle]
// pub extern fn push_public_key(batch: Value, public_key: Value) {
//     let mut batch = caml_opaque::acquire::<Batch>(batch);
//     let public_key = caml_opaque::acquire::<PublicKey>(public_key);
//     batch.push_public_key(*public_key)
// }

// #[no_mangle]
// pub extern fn verify_batch(batch: Value) -> Value {
//     let batch = caml_opaque::acquire::<Batch>(batch);
//     if ed25519_dalek::verify_batch(batch.messages.as_ref(), batch.signatures.as_ref(), batch.public_keys.as_ref()).is_ok() {
// 	caml_true()
//     } else {
// 	caml_false()
//     }
// }
