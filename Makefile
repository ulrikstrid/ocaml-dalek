RUST_ROOT = src/libdalek_rs/

cargo-fetch:
	cd $(RUST_ROOT) && cargo fetch && cd ../..

cargo-clean:
	cd $(RUST_ROOT) && cargo clean && cd ../..

TARGET = libdalek_rs

$(TARGET) = target/release/libdalek_rs.a target/release/libdalek_rs.so

target/release/libdalek_rs.a:
	cargo build --offline --release

target/release/libdalek_rs.so:
	cargo build --offline --release

clean:
	cargo clean
