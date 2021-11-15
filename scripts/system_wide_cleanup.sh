#! /usr/bin/bash

# Clear all docker storage --------------------------------
docker system prune -a -f
docker volume rm $(docker volume ls -qf dangling=true)

# Clear all pacman cache, leaving only 1 version behind ---
paccache -rk1

# Clear all yay cache --
yay -Sc

# Clear all pacman cache ----
pacman -Sc

# Clear all nuget cache ----------
dotnet nuget locals all --clear