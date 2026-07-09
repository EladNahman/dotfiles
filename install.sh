#!/usr/bin/env bash
# Bootstrap a new Mac from this repo. Idempotent — safe to re-run any time.
#
#   ./install.sh            # PERSONAL setup: how I work (shell, nvim, aerospace, …)
#
# Work/job setup is intentionally NOT in this repo — it's a standalone script
# carried between machines by hand.
#
# Individual steps:
#   ./install.sh brew       # just Homebrew + Brewfile
#   ./install.sh links      # just symlink dotfiles into place
#   ./install.sh langs      # node (nvm), rust, poetry
#   ./install.sh check      # verify the whole setup — safe anytime, changes nothing
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
STEP="${1:-all}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m ⚠\033[0m %s\n' "$*"; }

# ---------------------------------------------------------------- brew
do_brew() {
  if ! xcode-select -p >/dev/null 2>&1; then
    log "Installing Xcode Command Line Tools (accept the GUI prompt)…"
    xcode-select --install || true
    until xcode-select -p >/dev/null 2>&1; do sleep 10; done
  fi

  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

  # Non-official taps need explicit trust where HOMEBREW_REQUIRE_TAP_TRUST is enforced.
  # No-op on brew versions without `trust` or when the requirement is off.
  brew trust --tap nikitabobko/tap 2>/dev/null || true

  log "Installing packages from Brewfile…"
  brew bundle --file="$DOTFILES/Brewfile"
}

# ---------------------------------------------------------------- links
# link <repo-relative-source> <absolute-target>
link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return 0  # already linked
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${dst#"$HOME"/}")"
    mv "$dst" "$BACKUP_DIR/${dst#"$HOME"/}"
    warn "backed up existing $(basename "$dst") -> $BACKUP_DIR"
  fi
  ln -sn "$src" "$dst"
  log "linked $dst"
}

LINKS=(
  "zsh/.zshrc:$HOME/.zshrc"
  "zsh/.zprofile:$HOME/.zprofile"
  "zsh/.zshenv:$HOME/.zshenv"
  "git/.gitconfig:$HOME/.gitconfig"
  "git/ignore:$HOME/.config/git/ignore"
  "nvim:$HOME/.config/nvim"
  "tmux/tmux.conf:$HOME/.config/tmux/tmux.conf"
  "aerospace/aerospace.toml:$HOME/.aerospace.toml"
  "claude/settings.json:$HOME/.claude/settings.json"
)

do_links() {
  local entry
  for entry in "${LINKS[@]}"; do
    link "${entry%%:*}" "${entry#*:}"
  done

  # Per-machine files that must exist but are NOT in git
  if [ ! -f "$HOME/.gitconfig.local" ] || grep -q CHANGE-ME "$HOME/.gitconfig.local"; then
    if [ -t 0 ]; then
      printf 'git user.name for this machine: ';  read -r GITNAME
      printf 'git user.email for this machine: '; read -r GITEMAIL
      cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = $GITNAME
	email = $GITEMAIL
EOF
      log "wrote ~/.gitconfig.local"
    else
      cat > "$HOME/.gitconfig.local" <<'EOF'
[user]
	name = CHANGE-ME
	email = CHANGE-ME
EOF
      warn "created ~/.gitconfig.local with placeholders — edit it, or re-run './install.sh links' interactively"
    fi
  fi
  if [ ! -f "$HOME/.zshrc.local" ]; then
    cat > "$HOME/.zshrc.local" <<'EOF'
# Machine-local secrets & config. NOT in git — copy values from the old machine / 1Password.
# export SOME_WORK_TOKEN=...
EOF
    warn "created ~/.zshrc.local — copy your secrets into it (see MIGRATION.md)"
  fi
}

# ---------------------------------------------------------------- langs
do_langs() {
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"

  # node via nvm (brew's nvm needs ~/.nvm and manual sourcing)
  export NVM_DIR="$HOME/.nvm"
  mkdir -p "$NVM_DIR"
  if [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
    . "$(brew --prefix nvm)/nvm.sh"
    log "Installing node 20 + 24 via nvm…"
    nvm install 20
    nvm install 24
    nvm alias default 24
    corepack enable || true
  else
    warn "nvm not found — run './install.sh brew' first"
  fi

  # rust via rustup (creates ~/.cargo/env which .zshenv sources)
  if ! command -v rustup >/dev/null 2>&1 && [ ! -f "$HOME/.cargo/env" ]; then
    log "Installing rust via rustup…"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  # poetry via pipx
  if command -v pipx >/dev/null 2>&1; then
    pipx install poetry || true
  fi
}

# ---------------------------------------------------------------- check
do_check() {
  local fail=0 entry src dst t
  # make brew/nvm/cargo/pipx tools visible to this non-interactive shell
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)" || true
  export NVM_DIR="$HOME/.nvm"
  [ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh" >/dev/null 2>&1
  export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

  log "Symlinks:"
  for entry in "${LINKS[@]}"; do
    src="$DOTFILES/${entry%%:*}"; dst="${entry#*:}"
    if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
      printf '    ✓ %s\n' "$dst"
    else
      printf '    ✗ %s — not linked (run: ./install.sh links)\n' "$dst"; fail=1
    fi
  done

  log "Brew packages:"
  if brew bundle check --file="$DOTFILES/Brewfile" >/dev/null 2>&1; then
    printf '    ✓ everything in Brewfile installed\n'
  else
    printf '    ✗ missing (run: ./install.sh brew):\n'
    brew bundle check --verbose --file="$DOTFILES/Brewfile" 2>/dev/null | sed 's/^/      /' || true
    fail=1
  fi

  log "Tools on PATH:"
  for t in nvim tmux jq rg gh node npm pnpm yarn go cargo poetry claude; do
    if command -v "$t" >/dev/null 2>&1; then
      printf '    ✓ %-7s %s\n' "$t" "$(command -v "$t")"
    else
      printf '    ✗ %s missing\n' "$t"; fail=1
    fi
  done

  log "Per-machine files:"
  local gn ge
  gn="$(git config user.name 2>/dev/null || true)"; ge="$(git config user.email 2>/dev/null || true)"
  case "$gn$ge" in
    ''|*CHANGE-ME*) printf '    ✗ git identity — edit ~/.gitconfig.local by hand, or re-run ./install.sh links to be prompted\n'; fail=1 ;;
    *) printf '    ✓ git identity: %s <%s>\n' "$gn" "$ge" ;;
  esac
  if [ -f "$HOME/.zshrc.local" ]; then
    printf '    ✓ ~/.zshrc.local exists\n'
  else
    printf '    ✗ ~/.zshrc.local missing (secrets)\n'; fail=1
  fi

  echo
  if [ "$fail" = 0 ]; then log "All checks passed."; else warn "Some checks failed — fix the ✗ lines above and re-run './install.sh check'"; exit 1; fi
}

# ---------------------------------------------------------------- main
case "$STEP" in
  all)     do_brew; do_links; do_langs
           log "Personal setup done. Run the (non-git) work setup script for job tooling." ;;
  brew)    do_brew ;;
  links)   do_links ;;
  langs)   do_langs ;;
  check)   do_check ;;
  *) echo "usage: $0 [all|brew|links|langs|check]" >&2; exit 1 ;;
esac

log "Done. Open a new terminal. Then work through MIGRATION.md for the manual bits."
