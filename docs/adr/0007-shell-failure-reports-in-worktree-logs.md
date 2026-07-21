# Shell Failure Reports in worktree `logs/`

When the Shell Quality Gate fails shellcheck, the AI-ready report is written to **`logs/shellcheck-report-*.log` inside the current worktree** (and that path is printed). This matches the existing AGENTS.md contract and keeps reports visible next to the work the developer or agent is doing.

Trade-off accepted: reports disappear when a temporary worktree is removed, and `logs/` must be gitignored. We reject persisting only under `git-common-dir/hook-reports/` despite its worktree durability, to avoid a hidden side channel outside the working tree.

## Considered options

- **git-common-dir `hook-reports/`** — durable across worktrees; less visible; diverges from AGENTS.md.
- **Worktree `logs/` (chosen)** — visible, doc-aligned; lifecycle tied to the worktree.
- **stderr only** — no stable artifact for agents.
- **Both locations** — dual sources of truth.
