# One-time migration checklist (old Mac → new Mac)

`install.sh` handles everything installable. This is the checklist for things a script
*can't* do — secrets, data, and auth. Work-specific steps live in the standalone work
setup script (not in this repo). Work top to bottom.

## 0. BEFORE wiping / returning the old laptop

- [ ] **Push every work repo** — check for dirty files and unpushed commits:
      `for d in <work dirs>; do echo "$d"; git -C "$d" status --short; git -C "$d" log --branches --not --remotes --oneline; done`
- [ ] Push this dotfiles repo.
- [ ] Copy the work setup script to the new machine (it is NOT in git).
- [ ] Sweep `~/Desktop`, `~/Documents`, `~/Downloads` for anything not in git.

## 1. Secrets (transfer via password manager / secure channel — NEVER via this repo)

- [ ] `~/.zshrc.local` — recreate on the new machine with tokens from the old one
      (better: rotate any token that ever sat in plaintext).
- [ ] `~/.ssh/` — generate a fresh key on the new machine (`ssh-keygen -t ed25519`);
      copy old keys only if something still depends on them (e.g. the Parallels VM key).
- [ ] `~/.gitconfig.local` — set the git identity for the new machine.

## 2. Re-authenticate (don't copy tokens, just log in again)

- [ ] `gh auth login`
- [ ] Cloud / cluster / registry logins — see the work setup script.
- [ ] Claude Code (`claude`, then log in), Postman, TablePlus (license).
- [ ] 1Password, browser profiles, Slack, Spotify — all sync via account sign-in.

## 3. Data / heavyweight items

- [ ] **Parallels Windows VM** — copy the `.pvm` bundle (in `~/Parallels/`) via external
      disk/Migration Assistant, plus its ssh key. Needs a Parallels license.
- [ ] `apps/NvimKitty.app` in this repo → copy to `/Applications` (or `~/Documents`).
      If Gatekeeper complains: right-click → Open.
- [ ] Xcode from the App Store, if still needed.

## 4. Things intentionally left behind on the old (2026) machine

- Intel Homebrew at `/usr/local` — that machine had TWO brews (Intel + ARM); the Brewfile
  merges both, new machine gets one at `/opt/homebrew`.
- MacPorts — was only there for a mingw-w64 cross-toolchain; `brew "mingw-w64"` replaces it if ever needed.
- `~/.config/erospace.toml` — stale typo-named AeroSpace config; the real one is in this repo.
- `node`/`node@20` brew formulae — nvm owns node now.

## 5. Verify

- [ ] `zsh -ic 'echo $PATH'` — one brew (`/opt/homebrew`), nvm node, pnpm, dotfiles/bin all present
- [ ] `git config user.email` — correct identity
- [ ] `nvim` — plugins install on first launch (lazy.nvim reads `lazy-lock.json`)
- [ ] AeroSpace, kitty, tmux prefix (C-a) all behave like home
