# RaVN Dotfiles

Rewrite of the maintainer's Arch Linux dotfiles and tooling. This monorepo is
the **RaVN Dotfiles** product repository—not a generic public Bash template. It
hosts the Quality Gate, release automation, worktree-oriented Make workflow, and
the in-tree **ravn-cli** product CLI (phase-1 construction stubs).

## Get started

```bash
git clone git@github.com:robert-flo/dotfiles.git
cd dotfiles
make repository-bootstrap
make verify
```

Maintainers configuring the canonical GitHub repository:

```bash
make repository-bootstrap CONFIGURE_REMOTE=1
```

This installs the local Quality Gate for every clone. The maintainer-only path
also synchronizes Release Please labels and applies branch protection.

## What connects to what

```text
pre-commit Entrypoint
├── File Hygiene Gate
├── Doc Quality Gate
└── Shell Quality Gate (shfmt + shellcheck)
        │
        ├── make format / lint / test / verify
        ├── GitHub Actions on pull requests and master
        └── protected master: PRs, CI, resolved conversations

Conventional Commits ────────> Release Please ──> release PR ──> tag + GitHub Release
ravn-cli + runtime/ ─────────> product CLI (see docs/ravn-cli/)
```

Every change follows temporary branch → pull request → `master`. Release
Please opens a separate release pull request from releasable commits; merging
that pull request updates `CHANGELOG.md`, creates the `vX.Y.Z` tag, and
publishes the GitHub Release.

## Daily commands

| Command | Purpose |
| --- | --- |
| `make help` | List the supported interfaces. |
| `make format` | Apply repository formatting. |
| `make lint` | Run non-mutating hygiene, documentation, and shell checks. |
| `make test` | Run behavioral contracts. |
| `make verify` | Run lint and test together. |
| `make docker-build` | Build the monorepo starter container. |
| `make docker-run` | Run the starter executable in Docker. |
| `make docker-test` | Verify Docker output; skips when Docker is unavailable. |
| `make release-check` | Validate checked-in Release Please configuration. |
| `make release-status` | Show release PRs, releases, and token diagnostics. |
| `./ravn-cli` | Product CLI interactive menu (or `./ravn-cli <command>`). |
| `make ravn-cli-help` | Product CLI help without the menu. |

## Packaging boundaries

Upstream releases are source inputs for packaging. Each published release
attaches a reproducible source archive and matching `.sha256` file. A separate
AUR packaging repository may consume those assets and maintain its `PKGBUILD`,
`.SRCINFO`, checksums, and AUR publication. This product repository owns none
of those packaging artifacts.

## Documentation

- [Contributing](CONTRIBUTING.md)
- [ravn-cli product CLI](docs/ravn-cli/README.md)
- [Make command reference](docs/make/)
- [Repository map](docs/repository-map.md)
- [Domain vocabulary](CONTEXT.md)
- [Commit message guidelines](COMMIT_MESSAGE_GUIDELINES.md)
- [Release policy](RELEASE_POLICY.md)
- [Editor recommendations](.vscode/extensions.json)
- [MIT License](LICENSE)
