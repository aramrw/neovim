# Get the directory where this script is located
let script_dir = $env.FILE_PWD

# Define the wallpaper directory relative to the script's location
let WALLPAPER_DIR = ".././hyprland/wallpapers"

# List the wallpapers and select a random one
let wallpaper = ls $WALLPAPER_DIR | get path | random

# Check if a wallpaper was found and copy it to the desired location
if not ($wallpaper | is-empty) {
    cp $wallpaper /usr/share/hypr/wall0.png
} else {
    print -e $"No wallpapers found in ($WALLPAPER_DIR)"
}

