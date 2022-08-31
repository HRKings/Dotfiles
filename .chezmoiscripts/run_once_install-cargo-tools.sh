#! /bin/sh

cargo_tools=(
	evcxr_repl 			# Rust REPL
	cargo-update		# Update Cargo packages
	cargo-edit			# Edit the Cargo.toml easily
	biodiff					# Diff hexdumps using biological alignment algorithms
	evcxr_repl			# Rust REPL
)

# Install the packages ----------
cargo install "${cargo_tools[@]}"
