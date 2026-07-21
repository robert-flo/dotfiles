# Quality Gate bootstrap on setup and worktrees

An integrated Quality Gate that nobody installs is a paper gate. We expose an explicit **Gate Bootstrap** Make target (e.g. `hooks-install`) that verifies required host tools and runs `pre-commit install`, and we **also call that same target from `git-setup` / worktree creation** so new environments get the Entrypoint without a separate tribal step.

## Considered options

- **Bootstrap target only** — clear, but easy to skip when using other worktree paths.
- **Only inside git-setup** — automatic for one path; misses other clones.
- **Docs only** — status quo failure mode.
- **Bootstrap target + git-setup hook-up (chosen)** — one implementation, two call sites.

Bootstrap **verifies** host tools on `PATH` and fails with clear install hints; it does **not** auto-install system packages (avoids privilege and environment surprises). Package-list registration can be a later concern when installer package manifests live in-tree.
