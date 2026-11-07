# Profiles: `nix profile` vs `nix-env`

The commands use [`examples/01-hello-sh/default.nix`](../examples/01-hello-sh/README.md).

Both tools install into the same profile path,
`~/.local/state/nix/profiles/profile`, but with different formats:

- `nix profile` (new CLI) writes `manifest.json`.
- `nix-env` (legacy) writes `manifest.nix`.

A profile in one format cannot be used by the other tool.

## Converting to the legacy format

The default profile is created by whichever tool runs first. To hand it to
`nix-env`, remove the new-style profile and its generations:

```
$ rm -rf ~/.local/state/nix/profiles/profile ~/.local/state/nix/profiles/profile-*
$ rm -f  ~/.nix-profile
```

Removing only the `~/.nix-profile` symlink is **not** enough: `nix-env` recreates
it pointing at the same profile directory and still finds `manifest.json`.

Caveat: this discards the list of packages the new-style profile held; they stay
in the store but are no longer "installed".

## Alternative: give `nix-env` its own profile

Keeping the default profile untouched avoids the conversion altogether:

```
$ mkdir -p ~/profiles
$ nix-env --install --file default.nix --profile ~/profiles/legacy

$ ~/profiles/legacy/bin/hello.sh
hello world

$ nix-env --profile ~/profiles/legacy -q
hello.sh
```

The profile is then independent: `nix profile` keeps managing the default one.
The parent directory must exist, otherwise:
```
$ nix-env --install --file default.nix --profile ~/profiles/legacy
error: opening lock file "/home/i12e/profiles/legacy.lock": No such file or directory
```

## nix profile (new way)

Install:
```
$ nix profile add --file default.nix

$ nix profile list
Name:               hello.sh
Store paths:        /nix/store/0kd3jhn6ylpgpk0a9rr4dmw8z00ap6gy-hello.sh
```

## nix-env (old way)

Install:
```
$ nix-env --install --file default.nix

$ nix-env -q
hello.sh
```

Without converting the profile first:
```
$ nix-env --install --file default.nix
error: profile "/home/i12e/.local/state/nix/profiles/profile" is incompatible with 'nix-env'; please use 'nix profile' instead
```
