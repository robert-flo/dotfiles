# Contributing to this Bash project

Thank you for improving this Bash project. Bug fixes, scripts, documentation,
and tests are all welcome.

## Getting started

1. Fork the repository and clone your fork.

2. From the repository root, configure the local Quality Gate:

   ```bash
   make repository-bootstrap
   ```

   This installs the local pre-commit Entrypoint. Maintainers configuring the
   canonical repository additionally run
   `make repository-bootstrap CONFIGURE_REMOTE=1`; it replaces default-branch
   protection with the documented policy.

3. Create a focused topic branch in an isolated worktree:

   ```bash
   git-create-worktree -b type/short-description /wt/<repo>/short-description
   ```

4. Before opening a pull request, run the relevant checks:

   ```bash
   make verify
   ```

5. Commit atomically using the
   [commit message guidelines](COMMIT_MESSAGE_GUIDELINES.md), then push the
   branch and open a pull request targeting `master`.

## Releases and changelog

Use Conventional Commits with the optional Gitmoji after the type. Release
Please recognizes `feat`, `fix`, and breaking changes by default; it owns the
release pull request, `version.txt`, `CHANGELOG.md`, tags, and GitHub Releases.
Do not add changelog labels or manually edit generated release artifacts.

You can validate the checked-in release configuration locally:

```bash
make release-check
```

## Guidelines

- Keep changes focused and preserve the repository's existing configuration
  contracts unless the change explicitly updates them.
- Add or update tests for behavior changes.
- Do not commit tokens, private keys, personal credentials, or host-specific
  paths from a live machine.
- Describe the validations you ran in the pull request.
- Follow the [release policy](RELEASE_POLICY.md): direct commits and pushes to
  `master` are not allowed.

## References

- [Pull request template](.github/PULL_REQUEST_TEMPLATE.md)
- [Commit message guidelines](COMMIT_MESSAGE_GUIDELINES.md)
- [Release policy](RELEASE_POLICY.md)
- [Release Please diagnostics](make/release.mk)
- [Project README](README.md)
