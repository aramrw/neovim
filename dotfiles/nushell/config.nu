$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
const HOME = $nu.home-path;
source $"($nu.home-path)/.cargo/env.nu"

# theme
source "scripts/theme.nu"

# scripts
source "scripts/random.nu"
source "scripts/yazi.nu"
# source "scripts/hyprland-wallpaper.nu"

# env
source "./env.nu"

# alias
alias cfg.term = nvim $env.term


