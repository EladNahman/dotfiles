# dotfiles

Everything needed to turn a blank Mac into my machine — the **personal** layer only:
shell, nvim, tmux, AeroSpace, kitty, general CLI tools. It survives forever and moves
with me between jobs.

Job/work setup (employer tools, work repos) is intentionally **not in this repo** —
it lives in a standalone script carried between machines by hand.

Configs are **symlinked** from this repo into place — edit anywhere, `git commit` here,
every machine pulls the same setup.

## New machine

```sh
# 1. Sign in to GitHub in the browser, then:
git clone https://github.com/EladNahman/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh          # brew + apps + symlinks + node/rust/poetry
```

Then follow **MIGRATION.md** for secrets, auth, and data (one-time stuff a script can't do),
and run the work setup script.

## Layout

| Path | Becomes |
|---|---|
| `zsh/` | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `git/` | `~/.gitconfig` (identity stays in `~/.gitconfig.local`, per machine) + global ignore |
| `nvim/` | `~/.config/nvim` (lazy.nvim, plugins pinned by `lazy-lock.json`) |
| `tmux/`, `aerospace/` | tmux conf, `~/.aerospace.toml` |
| `claude/` | `~/.claude/settings.json` |
| `bin/` | personal scripts, on `$PATH` |
| `Brewfile` | personal CLI tools and apps |
| `apps/` | NvimKitty.app (Automator launcher) |

## Rules that keep this working

- **New tool?** Add it to the `Brewfile`, then `brew bundle --file=~/dotfiles/Brewfile`.
  Never bare `brew install`. Job-specific tools go in the work script, not here.
- **Secrets** go in `~/.zshrc.local`; git identity in `~/.gitconfig.local`. Neither is ever committed.
- **Config drift**: configs are symlinks into this repo, so `git -C ~/dotfiles status` shows any drift. Commit it.
- Re-running `./install.sh` (or any single step: `brew`, `links`, `langs`) is always safe.
