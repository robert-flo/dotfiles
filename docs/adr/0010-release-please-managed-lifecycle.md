# release please manages the release lifecycle

The template needs a release process that is useful immediately but does not
make every contributor calculate versions, curate changelog entries, or create
tags manually. Its durable public contract is Conventional Commits, a
`version.txt` file containing `X.Y.Z`, `vX.Y.Z` tags, and GitHub Releases.

Release Please is the sole release engine. It uses the `simple` strategy,
starts the template at `0.1.0`, and manages `CHANGELOG.md` from releasable
commit types. `feat` produces a minor release, `fix` a patch release, and a
breaking marker a major release. Gitmoji remains compatible because it follows
the Conventional Commit type.

The repository retains merge commits into `master` to preserve pull-request
history. Consequently, Release Please pull-request body overrides are not
available; commit messages are the release-intent interface.

## Considered options

- **Release Please with the simple strategy (chosen)** — one external,
  declarative lifecycle produces release pull requests, changelog updates,
  versions, tags, and GitHub Releases.
- **A pull-request label and local changelog generator** — duplicates release
  classification, requires manual release preparation, and leaves tags and
  GitHub Releases outside the same lifecycle.
- **Manual releases only** — keeps tooling small but makes the template less
  reliable and less useful as a reusable public-project baseline.
