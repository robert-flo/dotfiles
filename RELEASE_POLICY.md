# Pull Request and Branching Policy

This file is the canonical source for the repository's branch and pull-request
policy. Other contribution documents provide contextual instructions and link
back to this policy.

## Branch model

This repository uses `master` as its only permanent integration branch. It does
not use `dev` or `rc` branches.

All changes must follow this path:

```text
issue → temporary branch/worktree → pull request → master
```

## Rules for `master`

- Direct commits and pushes to `master` are not allowed.
- Every change must arrive through a pull request targeting `master`.
- The pull request must reference its issue and describe the validations run.
- Applicable CI checks must finish successfully before merge.
- Temporary branches are deleted after their pull requests are merged.
- Force pushes to `master` are not allowed.

Branch protection in GitHub is the enforcement mechanism for the pull-request
requirement. GitHub Actions validates changes but cannot prevent a direct push
after it has already occurred.

## Repository bootstrap

After cloning, run:

```bash
make repository-bootstrap CONFIGURE_REMOTE=1
```

Maintainers use this command for the canonical repository. It installs the
local Quality Gate, synchronizes changelog labels, and replaces the
default-branch protection with the policy below. Contributors should run
`make repository-bootstrap` to install only local hooks. Use `DRY_RUN=1`
to preview remote changes.

## Release lifecycle

1. A maintainer creates a temporary `release/<YY.M.patch>` branch from the
   current `master`.
2. The release preparation moves every entry under `## Unreleased` into a
   dated `## [YY.M.patch] - YYYY-MM-DD` section, preserving categories and
   restoring an empty `Unreleased` section.
3. The prepared release is validated in a pull request and merged into
   `master`.
4. From that merged commit, the maintainer creates the matching annotated tag
   and GitHub Release. A release tag must point at the merge commit on
   `master`, never at a topic branch.

The changelog generator is intentionally pull-request scoped. Release
preparation owns version headings and dates; it must not regenerate individual
pull-request entries.

## CI events

The validation workflow runs twice during the normal lifecycle:

1. On a pull request targeting `master`, before merge, to validate the proposed
   diff.
2. On a push to `master`, after the pull request is merged, to validate the
   resulting commit.

The second run is post-merge verification. The pull-request run and branch
protection are what guard `master` before the change lands.
