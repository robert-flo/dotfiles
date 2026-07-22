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
local Quality Gate and replaces default-branch protection with the policy
below. Contributors should run `make repository-bootstrap` to install only
local hooks. Use `DRY_RUN=1` to preview remote changes.

## Release lifecycle

Release Please owns the release lifecycle. On every push to `master`, it reads
releasable Conventional Commits and either updates its open release pull
request or publishes the release when that pull request is merged.

1. A `feat` increments the minor version; a `fix` increments the patch
   version; `!` or `BREAKING CHANGE:` increments the major version.
2. Release Please opens a release pull request labeled `autorelease: pending`.
   It updates `version.txt` and `CHANGELOG.md` in that pull request.
3. Merge that generated pull request into `master` using the normal merge
   commit policy.
4. Release Please creates the `vX.Y.Z` tag and GitHub Release, then applies
   `autorelease: tagged`.

The repository starts at `0.1.0` and stores versions as `X.Y.Z` in
`version.txt`. Release Please is the only component that calculates versions,
edits the changelog, creates release tags, or creates GitHub Releases.

The release workflow falls back to the repository `GITHUB_TOKEN` so a fresh
template can run. Maintainers should set the `RELEASE_PLEASE_TOKEN` secret to
a narrowly scoped maintainer token when the normal pull-request CI must run on
Release Please-created pull requests: GitHub does not trigger other workflows
from `GITHUB_TOKEN`-created events. Secrets are never committed.

Release Please cannot use pull-request body overrides when release pull
requests are merged with a merge commit. This repository deliberately keeps
merge commits for its integration history, so contributors express release
intent in Conventional Commit messages instead.

## CI events

The validation workflow runs twice during the normal lifecycle:

1. On a pull request targeting `master`, before merge, to validate the proposed
   diff.
2. On a push to `master`, after the pull request is merged, to validate the
   resulting commit.

The second run is post-merge verification. The pull-request run and branch
protection are what guard `master` before the change lands.
