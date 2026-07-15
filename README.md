# danielmitterdorfer/tap

Casks kept alive after being removed (or scheduled for removal) from the official Homebrew repos.

## Casks

- **logseq-og** — the file-based fork of Logseq at [logseq/og](https://github.com/logseq/og), not
  packaged by Homebrew upstream.
- **librewolf** — mirrors the official `homebrew-cask` formula, without the `disable!` scheduled for
  2026-09-01.

## Usage

```bash
brew tap danielmitterdorfer/tap
brew install --cask danielmitterdorfer/tap/logseq-og
brew install --cask danielmitterdorfer/tap/librewolf
```

## Updating a cask to a new version

Check whether upstream has released something newer:

```bash
brew livecheck --tap=danielmitterdorfer/tap
```

If a newer version is available, let Homebrew update the cask's `version`/`sha256` (and download
URL, if it changed) for you, then commit the result:

```bash
brew bump-cask-pr --write-only --commit danielmitterdorfer/tap/logseq-og
# or: danielmitterdorfer/tap/librewolf
```

`--write-only` (with `--commit`) makes the local file edit and commits it without opening a GitHub
pull request — appropriate for a personal tap with no collaborators. Push the commit once you're
happy with it:

```bash
cd "$(brew --repo danielmitterdorfer/tap)"
git push
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
