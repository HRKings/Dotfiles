#! /bin/bash

dotnet_tools=(
	dotnet-script		# Run .csx C# scripts
  csharprepl			# Interactive C# shell
)

# Get already installed .NET tools -------------------------------------------------
installed_dotnet_tools=$(dotnet tool list --global | tail -n +3 | awk '{print $1}')

# Install tools ---------------------------------------------------------------------------
for tool in "${dotnet_tools[@]}"
do
  # Only install if not already
  if [[ ! $installed_dotnet_tools =~ (^|[[:space:]])$tool($|[[:space:]]) ]]; then
    dotnet tool install --global "$tool"
  fi
done
