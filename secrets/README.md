# Secrets

A portable, versioned secrets store built on [sops](https://github.com/getsops/sops)
and [age](https://github.com/FiloSottile/age). Secrets are committed
**encrypted-at-rest** and can be carried between machines — including SSH private
keys.

This is standalone: you manage secrets manually with `just` recipes. Nothing is
wired into the NixOS / home-manager configs yet (see *Future* below).

## Layout

```
secrets/
  flake.nix     devshell: sops, age, ssh-to-age, rbw
  .sops.yaml    recipient rules — PUBLIC age keys only (safe to commit)
  justfile      workflow recipes
  store/        git submodule -> PRIVATE repo; holds encrypted secrets.yaml
```

### Why the public/private split

sops encrypts **values**, not keys. In an encrypted file the secret *names* and
structure (`example_token:`, `ssh_ed25519_private:`, …) stay in cleartext. This
outer `secrets/` dir lives in the public dotfiles repo (reusable machinery,
public age keys only). The encrypted data itself lives in a **separate private
repo** mounted at `store/`, so that metadata — and the blast radius of any
accidental plaintext slip — stays private.

## The trust model (read this once)

- The **root identity is a personal age key**. Its public half is a recipient in
  `.sops.yaml`; its private half lives at `~/.config/sops/age/keys.txt` and is
  backed up in **Bitwarden**, never committed.
- **SSH private keys are stored *inside* sops** as ordinary secrets.
- These two facts must not collapse into a loop: the thing that *unlocks* sops
  (the age key) is never one of the secrets stored *inside* sops. So a fresh
  machine bootstraps from Bitwarden (one step), then can decrypt everything —
  including its SSH keys.

## First-time setup (once, ever)

```bash
# 1. Generate your personal age key
age-keygen -o ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt

# 2. Put its PUBLIC key (the `age1…` "public key:" line) into .sops.yaml,
#    replacing the age1REPLACE… placeholder.

# 3. Back up the PRIVATE key to Bitwarden so new machines can bootstrap
cd secrets
just store-key        # paste the AGE-SECRET-KEY-… line
```

## Everyday use

```bash
cd secrets
just edit             # edit store/secrets.yaml (opens $EDITOR, re-encrypts on save)
just view             # decrypt store/secrets.yaml to stdout
```

## New machine

```bash
git submodule update --init secrets/store   # pull the private store
cd secrets
just bootstrap                              # restore age key from Bitwarden
just view                                   # confirm you can decrypt
just deploy-ssh                             # optional: drop the stored SSH key into ~/.ssh
```

## Adding another recipient (e.g. a machine's own key)

```bash
cd secrets
just add-machine ~/.ssh/id_ed25519   # prints an age1… key
# add that key under `age:` in .sops.yaml
just rekey                           # re-encrypt all secrets to the new recipient set
```

`ssh-to-age` derives an age key from an ed25519 SSH key, so a machine can decrypt
using a key it already has — no new secret to distribute. This is optional
convenience on top of the personal-key root.

## Future: home-manager consumption (not enabled)

To later let home-manager auto-materialize a secret, add the sops-nix input and
module to `../home-manager/flake.nix` / `home.nix`:

```nix
# flake input
inputs.sops-nix.url = "github:Mic92/sops-nix";

# in a home-manager module
imports = [ inputs.sops-nix.homeManagerModules.sops ];
sops = {
  age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  defaultSopsFile = ../secrets/store/secrets.yaml;
  secrets.example_token = {};   # -> $XDG_RUNTIME_DIR/secrets/example_token
};
```

The same encrypted `store/secrets.yaml` and the same age key are reused — this
layer is additive and off by default.
