# Brewfile — PERSONAL: how I work, on any machine, at any job.
# Work/job tooling lives in work/Brewfile (installed via `./install.sh work`).
#
# Merged from the old machine's TWO brew installs (Intel /usr/local + ARM /opt/homebrew).
# On the new machine there is exactly one brew, at /opt/homebrew.

# --- Taps ---
tap "nikitabobko/tap"    # AeroSpace lives in the developer's tap, not homebrew core

# --- CLI tools ---
brew "cmake"
brew "ffmpeg"
brew "gh"
brew "git-lfs"
brew "go"                # was a manual installer at /usr/local/go on the old machine
brew "jq"
brew "neovim"
brew "nvm"               # node itself managed by nvm — install.sh installs v20 + v24
brew "parallel"
brew "pipx"              # poetry installed via pipx in install.sh
brew "pnpm"
brew "python@3.13"
brew "ripgrep"
brew "rsync"
brew "tmux"
brew "yarn"

# --- Apps (casks) ---
cask "nikitabobko/tap/aerospace"
cask "claude-code"
cask "docker-desktop"
cask "kitty"
cask "logi-options+"
cask "postman"
cask "spotify"
cask "tableplus"
# cask "parallels"       # needs a license; the VM itself is migrated separately (see MIGRATION.md)

# NOT here on purpose (IT-managed / pushed by MDM): Company Portal, Microsoft Defender,
# security/VPN agents, Microsoft Edge, DisplayLink Manager.
# Xcode: install from the App Store (or `mas` if you want to automate it).
