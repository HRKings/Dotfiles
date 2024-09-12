#! /bin/bash

go_tools=(
	github.com/oklog/ulid/v2/cmd/ulid@latest		# Generate and parse ULID
)

# Install tools ---------------------------------------------------------------------------
for tool in "${go_tools[@]}"
do
	go install "$tool"
done
