# RaVN Dotfiles

Domain language for the **RaVN Dotfiles** product repository: a rewrite of the
maintainer's Arch Linux dotfiles and tooling. This monorepo is a **product**,
not a reusable public Bash project template. Vocabulary covers quality gates,
configuration tracking, agent workflow, and the in-tree **ravn-cli** product CLI.

## Language

### Product identity

**RaVN Dotfiles**:
The public name of this repository's product: the rewrite of the maintainer's
Arch Linux dotfiles and related tooling hosted at the `dotfiles` GitHub repo.
_Avoid_: Bash project template, generic public template, Use this template repo

**Product repository**:
This monorepo as the owned product codebase (docs, gates, ravn-cli, future
dotfile surfaces), not a starter skeleton meant for unrelated forks via GitHub
template mode.
_Avoid_: public template contract, template-facing README as the primary identity

**Public product docs**:
First-party documentation and GitHub forms that speak to RaVN Dotfiles
contributors and users (README, CONTRIBUTING, issue/PR templates, product
acceptance tests).
_Avoid_: template checklist "Customize before publishing", ban on product names in public docs

**Fresh-repo acceptance**:
The offline acceptance harness that materializes a clean tree and checks
release, bootstrap, and aggregate verification contracts for this product repo
(renamed from fresh-template acceptance).
_Avoid_: fresh template acceptance as the product name, public template contract as a required step

### Commit quality

**Quality Gate**:
The full set of automated checks that must pass before a commit is accepted, owned by a single Git entrypoint.
_Avoid_: pre-commit hooks (ambiguous), linters, CI (CI may re-run the same gate but is not the gate itself)

**Shell Quality Gate**:
The shell-specific portion of the Quality Gate: format, lint, and RaVN shell rules for staged shell files only.
_Avoid_: shell hook, bash lint (when referring to the whole gate), community shell hooks (as the primary implementation), exclusion allowlists for “legacy” shell

**Shell Failure Report**:
A timestamped, AI-oriented artifact produced when the Shell Quality Gate fails lint, with a path printed for humans and agents.
_Avoid_: hidden side-channel reports outside the working tree

**File Hygiene Gate**:
The non-shell portion of the Quality Gate for generic repository hygiene (size, conflict markers, symlinks, structured-file validity, whitespace, EOF).
_Avoid_: generic hooks, basic checks

**Doc Quality Gate**:
The Markdown portion of the Quality Gate for first-party project documentation that Git can stage.
_Avoid_: markdown hook (when referring to the whole doc policy), linting third-party or local agent skills

**Local Agent Tree**:
Developer-local agent skills and related files, ignored by Git and outside product source.
_Avoid_: project docs, tracked skills vendor directory

**Strict Doc Profile**:
The stricter Markdown rule set used by the Doc Quality Gate on commit, with only intentional project-convention exceptions.
_Avoid_: full default markdownlint (implies zero disables), lax profile (not the commit gate)

**Entrypoint**:
The single Git pre-commit hook installation that owns the Quality Gate; no second parallel hook owner.
_Avoid_: hooksPath dual setup, dual pre-commit systems

**Gate Bootstrap**:
The explicit install path that activates the Entrypoint in a clone or worktree and verifies required host tools without installing packages.
_Avoid_: “just run pre-commit install” as the only onboarding story, auto-install of system packages from bootstrap

**Full Gate Bypass**:
Emergency skip of the entire Quality Gate for one commit via Git’s native no-verify path.
_Avoid_: SKIP_HOOKS=1 (retired; previously implied “all hooks” but only affected shell)

**Selective Hook Skip**:
Skipping one or more named hooks inside the Quality Gate while leaving the rest active.
_Avoid_: SKIP_HOOKS (ambiguous), partial bypass

### ravn-cli

**ravn-cli**:
The public product CLI for this repository: a root launcher plus private runtime that evolves independently of the finished `git-setup` product it was scaffolded from.
_Avoid_: git-setup (the separate finished product), ravn-dot (Config sync TUI), make git-setup (bare clone + worktrees target)

**Template origin**:
The finished external product `git-setup` (and its modular command architecture) used as a one-shot construction base for ravn-cli; both products evolve independently with no required sync.
_Avoid_: upstream to reimport, submodule of git-setup, dual maintenance

**Launcher**:
The small root executable `ravn-cli` that starts the runtime, shows the interactive menu or dispatches a command, and does not call command-module internals as functions.
_Avoid_: command module, installed payload path as the only entry

**Runtime payload**:
The private `runtime/` tree beside the launcher: helpers, libraries, executable command modules, command catalog, completion, and templates retained as construction examples.
_Avoid_: public monorepo Make surface, Quality Gate hooks

**Command module**:
An executable under `runtime/scripts/` that implements one public operation, invocable both directly and via the launcher/dispatcher with the same contract.
_Avoid_: private helper, Make target

**Command catalog**:
The language-neutral `runtime/commands.tsv` contract (canonical name, aliases, label, description, icon, menu flag, options) shared by dispatch, menu, help, and completion.
_Avoid_: hard-coded menu-only lists, shell-specific metadata as sole source of truth

**Flat command surface**:
Public operations addressed as top-level names under ravn-cli (e.g. `ravn-cli setup`), including future non-Git operations at the same level—not nested under a `git` subcommand group in phase 1.
_Avoid_: namespaced `ravn-cli git setup` as the phase-1 contract

**Construction stub**:
A command module that keeps the real module skeleton (bootstrap, sources, entrypoint, help shape, visual `print_*` language) but replaces domain side effects with a harmless stub message for phase 1.
_Avoid_: production Git/SSH/GPG setup behavior, empty file without contract

**Design language**:
The shared interactive presentation of the template origin: RAVN banner box, section/step/success/error/warn/info printers, Nerd Font icons, numbered menu plus `h`/`q`, and menu continuity after recoverable command failure.
_Avoid_: unrelated TUI frameworks, mandatory fzf for the main menu

**Product Make surface**:
Make fragments and workflow companions isolated under `make/ravn-cli/`, included without overriding the monorepo’s existing `make/git.mk`, `docker.mk`, `aliases.mk`, hooks, quality, or release targets.
_Avoid_: overwriting monorepo Make with git-setup’s Make, shared unprefixed `docker-run` for both products

**Prefixed product target**:
A Make target belonging to the product Make surface, always named with the `ravn-cli-` prefix (e.g. `ravn-cli-docker-run`).
_Avoid_: unprefixed `docker-run` / `git-setup` for the product CLI

**Product Docker surface**:
Dockerfiles and image tags owned by ravn-cli under `docker/ravn-cli/`, distinct from the monorepo root `Dockerfile`.
_Avoid_: replacing the monorepo root Docker trial entrypoint

**Product test surface**:
Automated tests for ravn-cli under `tests/ravn-cli/`.
_Avoid_: overloading monorepo quality/make contract tests without a product boundary
