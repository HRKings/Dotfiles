#! /bin/bash

cargo_tools=(
	ast-grep             # Grep but for code (support AST searching and replacing)
	biodiff              # Diff hexdumps using biological alignment algorithms
	cargo-cache          # Display information on the cargo cache
	cargo-clean-all      # Clean the target directories from various Rust projects
	cargo-edit           # Edit the Cargo.toml easily
	cargo-expand         # Show the results of a macro expansion
	cargo-generate       # Create Rust projects using templates
	cargo-information    # Show information of a crate
	cargo-llvm-cov       # Generate source-based code coverage
	cargo-nextest        # A better test runner for Rust
	cargo-quickinstall   # A fallback fro binstall
	cargo-shear          # Detect and remove unused dependencies
	cargo-show-asm       # View the ASM output of a compiled function
	cargo-update         # Update Cargo packages
	coreutils            # GNU core utilities rewritten in Rust
	evcxr_jupyter        # Rust Jupyter notebook support
	fnm                  # Fast Node Manager, because having just one circle of hell isn't enough
	irust                # Rust REPL
	jwt-cli              # Fast JWL encoding and decoding
	pest-language-server # LSP for Pest parser language
	rnr                  # Rename multiple files on a directory with support for regex
)

# Install the packages ----------
cargo binstall "${cargo_tools[@]}"
