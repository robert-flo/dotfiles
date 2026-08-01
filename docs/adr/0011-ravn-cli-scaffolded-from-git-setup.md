# ravn-cli is scaffolded from git-setup, then evolves alone

We need a modular interactive CLI in this monorepo without designing the
launcher/runtime/menu seam from scratch. We take a one-shot copy of the finished
external product **git-setup** (command modules, `runtime/`, design language) as
the construction base, rename the public product to **ravn-cli**, and let both
codebases evolve independently with no submodule or ongoing reimport duty.

Phase 1 keeps an almost-full tree (libs, templates, workflow, completion, product
Make/Docker/tests) as construction examples, but command modules are
**construction stubs**: real skeletons and visual language, no live Git/SSH/GPG
side effects. Operational dependency checks are relaxed so the menu remains
usable; the dependency-check structure stays for future non-Git package probes.

Public commands stay a **flat** surface under `ravn-cli`. Product Make lives under
`make/ravn-cli/` with **`ravn-cli-` prefixed** targets so it never collides with
monorepo `make git-setup` (bare/worktrees) or existing Docker aliases. Product
Docker and tests live under `docker/ravn-cli/` and `tests/ravn-cli/`. Internal
product prefixes use `RAVN_CLI_*`; user-facing strings say `ravn-cli`, not
`git-setup`. The interactive banner stays nearly identical to the template
origin for design-language continuity.

## Considered options

- **Port git-setup 1:1 as a live Git toolkit in-tree** — rejected for phase 1;
  the destination product is not “git-setup renamed,” and full key/config
  behavior would fight the stub-first plan.
- **New RaVN launcher with only minimal stubs, no full tree** — rejected; we
  explicitly want the full construction example tree even when much is dead.
- **Namespace commands under `ravn-cli git …`** — rejected for phase 1 in favor
  of a flat surface matching the template menu.
- **Overwrite monorepo Make/Docker with git-setup’s** — rejected; monorepo Make
  is larger and owns Quality Gate / worktree flows. Parallel product surface
  instead.
- **Keep git-setup as submodule/upstream** — rejected; independent evolution
  after the one-shot base copy.

## Consequences

- Expect dead or unexercised payload in phase 1 until stubs are replaced by real
  command modules.
- Agents must not treat `make git-setup` (bare clone) as the ravn-cli product, nor
  treat external git-setup as something this repo must stay in sync with.
- Later RaVN-native operations add rows to `commands.tsv` and modules under
  `runtime/scripts/` without renaming the launcher.
