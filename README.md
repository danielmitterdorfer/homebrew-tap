# danielmitterdorfer/tap

Casks kept alive after being removed (or scheduled for removal) from the official Homebrew repos.

## Casks

- **logseq-og** — the file-based fork of Logseq at [logseq/og](https://github.com/logseq/og), not
  packaged by Homebrew upstream.
- **librewolf** — mirrors the official `homebrew-cask` formula, without the `disable!` scheduled for
  2026-09-01.

## Usage

```
brew tap danielmitterdorfer/tap
brew install --cask danielmitterdorfer/tap/logseq-og
brew install --cask danielmitterdorfer/tap/librewolf
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
