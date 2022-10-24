TARGET = libdalek_rs

$(TARGET) = target/debug/libdalek_rs.a target/debug/libdalek_rs.so

target/debug/libdalek_rs.a:
	cargo build --offline

target/debug/libdalek_rs.so:
	cargo build --offline

clean:
	cargo clean
