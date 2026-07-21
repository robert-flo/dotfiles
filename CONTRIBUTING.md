# Contributing to RaVN Dotfiles

Thank you for improving RaVN Dotfiles. Bug fixes, configuration improvements,
documentation, and tests are all welcome.

## Getting started

1. Fork the repository and clone your fork.

2. From the repository root, configure the local Quality Gate:

   ```bash
   make repository-bootstrap
   ```

   This installs the local pre-commit Entrypoint. Maintainers configuring the
   canonical repository additionally run
   `make repository-bootstrap CONFIGURE_REMOTE=1`; it synchronizes changelog
   labels and replaces default-branch protection with the documented policy.

3. Create a focused topic branch in an isolated worktree:

   ```bash
   git-create-worktree -b type/short-description /wt/dotfiles/short-description
   ```

4. Before opening a pull request, run the relevant checks:

   ```bash
   pre-commit run --all-files
   bash tests/changelog-automation.sh
   ```

5. Commit atomically using the
   [commit message guidelines](COMMIT_MESSAGE_GUIDELINES.md), then push the
   branch and open a pull request targeting `master`.

## Changelog

Every pull request needs exactly one `changelog:<category>` label or
`changelog:skip`. Generate and review the entry locally before committing:

```bash
make changelog-update PR=<number>
```

The pull-request workflow verifies that the committed result matches the
selected label and pull-request metadata.

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
- [Project README](README.md)
