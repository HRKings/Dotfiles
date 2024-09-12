#! /bin/bash

browsers=(
	"thorium"
	"zen-bin"
)

# Create 1Password customization folder ---
sudo mkdir -p /etc/1password || true

# Create the allowed browsers file ---------------
sudo touch /etc/1password/custom_allowed_browsers

# Add the browsers to the file -----------------------------
for browser in "${browsers[@]}"
do
	echo "$browser" | sudo tee -a /etc/1password/custom_allowed_browsers
done
