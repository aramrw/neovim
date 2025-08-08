#!/usr/bin/env nu

# Define the directory where your wallpapers are stored
let WALLPAPER_DIR = ".././dotfiles/hyprland/wallpapers"

# Get a random wallpaper from the directory
let wallpaper = ls $WALLPAPER_DIR | random

# Copy the selected wallpaper to the location Hyprland uses
cp $wallpaper.path /usr/share/hypr/wall0.png
