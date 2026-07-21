# RaVN Dotfiles

Domain language for the RaVN Arch Linux utility/dotfiles repository — quality gates, configuration tracking, and agent workflow vocabulary that are specific to this project.

## Language

### Commit quality

**Quality Gate**:
The full set of automated checks that must pass before a commit is accepted. Owned by the `pre-commit` framework as the single Git entrypoint.
_Avoid_: pre-commit hooks (ambiguous), linters, CI (CI may re-run the same gate but is not the gate itself)

**Shell Quality Gate**:
The shell-specific portion of the Quality Gate: format with `shfmt`, lint with `shellcheck`, plus RaVN-specific rules (staged-only selection, partial-stage refusal, AI-ready failure reports). Implemented as a `pre-commit` **local hook** that runs the RaVN-owned script under `.git-hooks/`; not replaced by third-party shfmt/shellcheck hooks. Failure reports are written under the worktree’s `logs/` directory (not git-common-dir). **No transitional path exclusions**: every staged shell file is in scope.
_Avoid_: shell hook, bash lint (when referring to the whole gate), community shell hooks (as the primary implementation), exclusion allowlists for “legacy” shell

**Shell Failure Report**:
A timestamped, AI-oriented log produced when the Shell Quality Gate fails shellcheck. Lives at `logs/shellcheck-report-<timestamp>.log` inside the current worktree; path is printed on failure for agents/humans to open.
_Avoid_: hook-reports under git-common-dir (rejected for this repo’s preferred visibility)

**File Hygiene Gate**:
The non-shell portion of the Quality Gate that checks generic repository hygiene (large files, merge conflict markers, broken symlinks, structured-file syntax, trailing whitespace, end-of-file newlines).
_Avoid_: generic hooks, basic checks

**Doc Quality Gate**:
The Markdown portion of the Quality Gate. Runs via the pre-commit-managed `markdownlint-cli2` toolchain (not Docker on the commit path). Commit policy is the project **strict** markdownlint profile. Scope is first-party project documentation that Git can stage. Local agent skill trees under `.agents/` are outside the repository via `.gitignore`, so they are not part of the gate’s normal input set.
_Avoid_: markdown hook (when referring to the whole doc policy), markdownlint-cli2-docker (as the commit-path implementation), linting third-party skills

**Local Agent Tree**:
Developer-local agent skills and related files under `.agents/` (and the local `skills-lock.json`), ignored by Git. Not product source; not an input to the Quality Gate unless force-added.
_Avoid_: project docs, tracked skills vendor directory

**Strict Doc Profile**:
The markdownlint rule set used by the Doc Quality Gate on commit. Stricter than a legacy-debt profile; may still disable a small set of rules required by intentional project conventions (e.g. HTML for badges). Canonical on-disk source: `.markdownlint.yaml` (single file; no parallel `.json` or `-strict` twin for commit policy).
_Avoid_: full default markdownlint (implies zero disables), lax profile (not the commit gate), `.markdownlint-strict.yaml` as a second live commit config

**Entrypoint**:
The single Git `pre-commit` hook installed by the `pre-commit` framework. All Quality Gate domains run under this entrypoint; there is no second parallel Git hook owner.
_Avoid_: hooksPath dual setup, dual pre-commit systems

**Gate Bootstrap**:
The explicit install path that activates the Entrypoint in a clone or worktree (canonical Make target, also invoked from `git-setup` / worktree creation). Verifies that required host tools (`pre-commit`, `shfmt`, `shellcheck`) are on `PATH` and fails with install hints if not; does not install system packages itself.
_Avoid_: “just run pre-commit install” as the only onboarding story, auto-pacman/pip from the bootstrap target

**Full Gate Bypass**:
Emergency skip of the entire Quality Gate for one commit. Canonical mechanism: `git commit --no-verify` (Git-native).
_Avoid_: SKIP_HOOKS=1 (retired; previously implied “all hooks” but only affected the shell script)

**Selective Hook Skip**:
Skipping one or more named hooks inside the Quality Gate while leaving the rest active. Canonical mechanism: pre-commit’s `SKIP=<hook-id>[,<hook-id>…]` (e.g. `SKIP=ravn-shell-quality`).
_Avoid_: SKIP_HOOKS (ambiguous), partial bypass
