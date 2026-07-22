# Bash project template

An opinionated starting point for public Bash packages, command-line tools, and
dotfiles. It gives a new project a working executable, Docker baseline, quality
gate, protected pull-request workflow, and automated releases before project
logic exists.

## Start a project

Select **Use this template** on GitHub to create a new repository with a fresh,
unrelated one-commit history. Clone or fork this repository instead when you
want to retain its complete development history.

```bash
git clone <your-repository-url>
cd <your-repository-name>
make repository-bootstrap
make verify
```

Maintainers configure the canonical GitHub repository deliberately:

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

Dockerfile + dockerfile.sh ──> reproducible executable baseline
Conventional Commits ────────> Release Please ──> release PR ──> tag + GitHub Release
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
| `make docker-build` | Build the starter container. |
| `make docker-run` | Run the starter executable in Docker. |
| `make docker-test` | Verify Docker output; skips when Docker is unavailable. |
| `make release-check` | Validate checked-in Release Please configuration. |
| `make release-status` | Show release PRs, releases, and token diagnostics. |

The starter `dockerfile.sh` prints `Hello, world!`. Replace it and update the
Dockerfile as project behavior takes shape.

## Customize before publishing

- [ ] Rename the repository, update its description, and replace repository URLs.
- [ ] Replace ownership references and review the copyright holder in `LICENSE`.
- [ ] Choose the license text and update its details if MIT is not appropriate.
- [ ] Replace `dockerfile.sh`, Docker image behavior, and package metadata.
- [ ] Confirm `version.txt`, Release Please labels, and release permissions.
- [ ] Review issue forms, pull-request guidance, editor recommendations, and
      repository policies for the project's audience.
- [ ] Remove template examples and add the project's own usage, requirements,
      support, and security information.

## Packaging boundaries

Upstream releases are source inputs for packaging. A separate AUR packaging
repository may consume a release archive and maintain its `PKGBUILD`,
`.SRCINFO`, checksums, and AUR publication. This template owns none of those
packaging artifacts.

## Documentation

- [Contributing](CONTRIBUTING.md)
- [Commit message guidelines](COMMIT_MESSAGE_GUIDELINES.md)
- [Release policy](RELEASE_POLICY.md)
- [Editor recommendations](.vscode/extensions.json)
- [MIT License](LICENSE)
