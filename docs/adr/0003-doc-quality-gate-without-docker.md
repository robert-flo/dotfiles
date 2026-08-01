# Doc Quality Gate without Docker on the commit path

The draft `.pre-commit-config.yaml` used `markdownlint-cli2-docker`, which makes every Markdown-touching commit depend on a working Docker daemon. That breaks the integrated Quality Gate in minimal worktrees, agent sandboxes, and environments where shell tools exist but Docker does not.

We run the Doc Quality Gate with **pre-commit-managed `markdownlint-cli2`** (Node toolchain cached by the framework). Version pinning stays in `.pre-commit-config.yaml` via `rev:`; config files remain the policy source.

## Considered options

- **Local/framework-managed markdownlint-cli2 (chosen)** — portable commit path; same rule files.
- **Docker hook on every commit** — reproducible image, fragile prerequisite.
- **Markdown only in CI** — lighter commits; incomplete local Quality Gate.
- **Dual local+Docker hook ids** — unnecessary complexity once `rev` is pinned.
