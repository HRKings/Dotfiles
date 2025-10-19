def "cache clear" [] {
  gum confirm "Are you sure you want to clear all caches?"
  print ""

	gum style --bold --foreground 1  "Clearing Docker..."
	docker system prune -f
	print ""

	gum style --bold --foreground 1  "Clearing AUR..."
	yay -Sc
	paru -Sc
	print ""

	gum style --bold --foreground 1  "Clearing dotNet..."
	dotnet nuget locals --clear all
  print ""

	gum style --bold --foreground 1  "Clearing Cargo..."
	cargo cache -a
}
