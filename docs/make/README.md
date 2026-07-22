# Make command reference

`make help` is the public command catalog. This page adds the intent, safe
usage boundary, and a few representative workflows for the targets it exposes.
Aliases are short forms only; use the canonical target names in automation and
documentation.

## Examples

Start a new repository as its maintainer:

```bash
make repository-bootstrap CONFIGURE_REMOTE=1
make repository-protection-status
```

Prepare a documented change and verify it before opening a pull request:

```bash
make git-cm MSG="docs: 📝 describe the command surface"
make verify
```

Check the starter container or inspect an automated release without changing
remote state:

```bash
make docker-test
make release-status
```

## Finding commands

| Command | Use it when | Why it exists |
| --- | --- | --- |
| `make help` | You need the full public catalog. | Combines the category help targets. |
| `make help-git` | You are working with branches or GitHub policy. | Lists the canonical Git workflow. |
| `make help-docker` | You are validating the starter container. | Lists the Docker baseline commands. |
| `make help-aliases` | You encounter a short historical command. | Maps aliases to their canonical targets. |
| `make help-hooks` | You are setting up a clone. | Explains Quality Gate installation. |
| `make help-quality` | You need local validation commands. | Separates formatting from non-mutating checks. |
| `make help-release` | You are checking release automation. | Lists Release Please diagnostics. |

## Git and repository policy

| Command | Use it when | Why it exists |
| --- | --- | --- |
| `make git-add` | You want to stage the current worktree. | Provides a visible staging checkpoint. |
| `make git-commit` | A quick timestamped snapshot is appropriate. | Captures local work without writing a message manually. |
| `make git-cm MSG="..."` | You need an intentional Conventional Commit. | Records release intent and context explicitly. |
| `make git-add-commit` | A small change is ready in one step. | Combines staging and a timestamped commit. |
| `make git-push` | Your topic branch is ready for GitHub. | Publishes the current branch. |
| `make git-pull` | You need the remote branch locally. | Updates the current branch from its upstream. |
| `make git-status` | You need a safe state overview. | Shows branch, changes, and working-tree status. |
| `make git-diff` | You want to inspect unstaged work. | Makes local changes reviewable before staging. |
| `make git-log` | You need recent history. | Provides a concise commit view. |
| `make git-add-fuzzy` | You want to choose files interactively. | Uses `fzf` to avoid staging unrelated changes. |
| `make git-amend MSG="..."` | You must correct the latest local commit. | Updates its content or message before sharing it. |
| `make git-clean` | You want to remove merged, clean worktrees. | Reviews candidates and asks before deletion. |
| `make git-diff-fuzzy` | You want to inspect a past commit. | Selects a commit interactively with `fzf` or `peco`. |
| `make git-search CODE="..."` | You need the commit that changed text or a message. | Searches history by code delta or commit subject. |
| `make git-setup REPO="..."` | You are creating a managed bare clone and worktrees. | Establishes the repository's isolated-worktree workflow. |
| `make git-sync` | Topic worktrees need the current base branch. | Rebases local topic branches onto `origin/master`. |
| `make git-diff-dev` | A repository still uses `dev` and `rc`. | Compares those two integration stages. |
| `make git-diff-rc` | A repository still uses `rc`. | Compares its release candidate with `master`. |
| `make git-diff-here` | You need the current worktree against its base. | Shows the branch delta before a pull request. |
| `make git-protect-default-branch GIT_REPLACE_PROTECTION=1` | A maintainer deliberately replaces protection. | Applies the template's PR and CI policy. |
| `make repository-protection-status` | You want to audit protection safely. | Reports compliance without changing GitHub. |
| `make git-configure-release-labels` | Release Please labels are absent or drifted. | Synchronizes its lifecycle labels on GitHub. |
| `make repository-bootstrap` | You have cloned or created a local worktree. | Installs the local Quality Gate Entrypoint. |
| `make repository-bootstrap CONFIGURE_REMOTE=1` | You administer a fresh template-derived repository. | Adds lifecycle labels and applies default-branch protection. |

## Docker baseline

| Command | Use it when | Why it exists |
| --- | --- | --- |
| `make docker-build` | You need the local starter image. | Builds the reproducible container baseline. |
| `make docker-run` | You want to see the container's behavior. | Runs the image and prints its output. |
| `make docker-test` | You need a portable container smoke test. | Verifies expected output and skips cleanly without Docker. |
| `make docker-clean` | You want to reclaim the managed image. | Removes only the image owned by this template. |

## Quality Gate

| Command | Use it when | Why it exists |
| --- | --- | --- |
| `make hooks-install` | Required tools are installed in a clone. | Activates the single pre-commit Entrypoint. |
| `make format` | You deliberately want formatting changes. | Applies repository formatting; it may rewrite files. |
| `make lint` | You want non-mutating quality feedback. | Audits file hygiene, documentation, and shell quality. |
| `make test` | You want behavioral contracts only. | Runs the repository's non-mutating checks. |
| `make verify` | You are ready for the full local acceptance check. | Runs both lint and behavioral contracts. |

## Release Please diagnostics

| Command | Use it when | Why it exists |
| --- | --- | --- |
| `make release-check` | You changed release configuration locally. | Validates checked-in Release Please state without publishing. |
| `make release-status` | You need current GitHub release information. | Shows pending release PRs, recent releases, and token diagnostics. |

## Compatibility aliases

`make help-aliases` lists every supported alias. They are redirects to canonical
targets and intentionally have no distinct behavior. Prefer canonical names in
scripts; aliases such as `make a`, `make ac`, `make dt`, and `make clean` are
for interactive convenience.
