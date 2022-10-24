RUST_ROOT = src/libdalek_rs/

cargo-fetch:
	cd $(RUST_ROOT) && cargo fetch && cd ../..

cargo-clean:
	cd $(RUST_ROOT) && cargo clean && cd ../..
