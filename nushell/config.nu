$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.EDITOR = "nvim"
const HOME = $nu.home-path;
source $"($nu.home-path)/.cargo/env.nu"

# theme
# source ~/.config/nushell/theme.nu

# scripts
source "./scripts/random.nu"

# env
source "./env.nu"

# alias
alias cfg.term = nvim $env.term


