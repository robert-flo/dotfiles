# ravn-cli

**ravn-cli** is the product CLI in this monorepo: a root launcher plus a private
**runtime payload**. It was scaffolded from the finished external product
**git-setup** (the **template origin**) and evolves independently. It is not
**ravn-dot** (Config sync TUI) and not `make git-setup` (bare clone + worktrees).

Phase 1 ships **construction stubs**: real module skeletons and design language,
without live Git, GitHub, SSH, or GPG side effects.

## Surfaces

| Surface | Location | Role |
| --- | --- | --- |
| Launcher | `ravn-cli` (repo root) | Interactive menu or `ravn-cli <command>` dispatch |
| Runtime payload | `runtime/` | Catalog, libs, scripts, templates, completion |
| Command catalog | `runtime/commands.tsv` | Canonical names, aliases, labels, icons, menu flags |
| Command modules | `runtime/scripts/*` | Executable operations (stubs in phase 1) |
| Product tests | `tests/ravn-cli/` | Process-seam contracts (`t4-process-suite.sh` runs them) |
| Product Make | `make/ravn-cli/` | Prefixed targets only (`ravn-cli-*`) |
| Product Docker | `docker/ravn-cli/` | Ephemeral trial images (`ravn-cli:*` tags) |
| Workflow examples | `make/ravn-cli/workflow/` | Construction companions; stubs do not install them |

## Domain vocabulary

See [CONTEXT.md](../../CONTEXT.md) § **ravn-cli** and
[ADR-0011](../adr/0011-ravn-cli-scaffolded-from-git-setup.md).

## Try it

```bash
# Interactive menu (design language from the template origin)
./ravn-cli

# Direct command modules (construction stubs)
./ravn-cli help
./ravn-cli verify
./ravn-cli demo

# Product tests
bash tests/ravn-cli/t4-process-suite.sh

# Prefixed Make (does not redefine monorepo docker-run)
make ravn-cli-help
make help-ravn-cli-docker
make ravn-cli-docker-run   # requires Docker; ephemeral trial
```

## Phase 1 behavior

- Menu and CLI share the same process seam (dispatcher → executable module).
- Operational dependency checks are relaxed; the structure remains for later package sets.
- `clean` exits non-zero as a recoverable stub (menu continues; direct CLI propagates status).
- Identity defaults and dead payload (templates, configuration helpers, workflow companions) are construction examples only.

## Not in scope of phase 1

- Real setup/verify of SSH, GPG, GitHub, or managed Git config files.
- Syncing with external git-setup.
- Replacing monorepo Quality Gate, Release Please, or `make git-setup` worktrees.
