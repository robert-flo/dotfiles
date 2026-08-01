# Repository map

This concise map covers every versioned file except `tests/`, whose files are
executable verification contracts rather than template building blocks. Update
this map whenever an in-scope file is added, removed, or changes purpose.

## Repository root

| File | Purpose and reason |
| --- | --- |
| `.directory` | Sets the repository folder icon so graphical file managers identify the project. |
| `.dockerignore` | Excludes unnecessary files from Docker build contexts to keep validation images small. |
| `.editorconfig` | Establishes shared editor defaults so contributors produce compatible text files. |
| `.gitignore` | Prevents local outputs, logs, and user-specific artifacts from becoming history. |
| `.markdownlint.yaml` | Defines Markdown quality rules, including Release Please changelog compatibility. |
| `.pre-commit-config.yaml` | Declares the single local quality-gate entrypoint used before commits. |
| `.release-please-manifest.json` | Stores the current Release Please package version for automated releases. |
| `AGENTS.md` | Gives contributors and coding agents the repository workflow, safety, and quality rules. |
| `CHANGELOG.md` | Records released user-visible changes and is maintained by Release Please. |
| `COMMIT_MESSAGE_GUIDELINES.md` | Defines the Conventional Commit and Gitmoji conventions that feed release automation. |
| `CONTEXT.md` | Records shared domain vocabulary and architectural context for ongoing work. |
| `CONTRIBUTING.md` | Explains how to contribute safely, consistently, and through pull requests. |
| `Dockerfile` | Provides a clean container environment for template verification. |
| `LICENSE` | States the legal terms under which the template can be used and redistributed. |
| `Makefile` | Composes the focused `make/` modules into the public command interface. |
| `README.md` | Introduces the template and routes users to setup, commands, and policies. |
| `RELEASE_POLICY.md` | Documents the automated release lifecycle and maintainer responsibilities. |
| `dockerfile.sh` | Provides the executable Hello World payload verified by the Docker contract. |
| `release-please-config.json` | Configures Release Please changelogs, release assets, and Gitmoji commit titles. |
| `version.txt` | Supplies the template version consumed by its release and verification contracts. |
| `ravn-cli` | Root launcher for the ravn-cli product: interactive menu and command dispatch. |

## ravn-cli runtime payload

| File | Purpose and reason |
| --- | --- |
| `runtime/commands.tsv` | Language-neutral command catalog for menu, dispatch, help, and completion. |
| `runtime/helper/set_variable.sh` | Shared product path and identity variables (`RAVN_CLI_*` and domain paths). |
| `runtime/lib/command_catalog.sh` | Loads and queries the command catalog for launchers and modules. |
| `runtime/lib/command_interface.sh` | Shared entrypoint helper for module help versus operation dispatch. |
| `runtime/lib/configuration.sh` | Construction-example Git config generation helpers (unused by phase-1 stubs). |
| `runtime/lib/dependencies.sh` | Operational package probes (relaxed in phase 1; structure kept for later). |
| `runtime/lib/dispatch.sh` | Resolves catalog names and executes command modules as processes. |
| `runtime/lib/keys.sh` | Construction-example SSH/GPG key lookup helpers (unused by phase-1 stubs). |
| `runtime/lib/lifecycle.sh` | Runtime cleanup trap shared by the launcher. |
| `runtime/lib/presentation.sh` | Shared design-language printers, colors, and icons for ravn-cli. |
| `runtime/completion/ravn-cli.bash` | Bash completion for ravn-cli derived from the command catalog. |
| `runtime/completion/_ravn-cli` | Zsh completion for ravn-cli derived from the command catalog. |
| `runtime/templates/git/config` | Template for managed Git config generation (construction example). |
| `runtime/templates/git/delta.gitconfig` | Template for delta presentation config. |
| `runtime/templates/git/gitattributes.global` | Template for global gitattributes. |
| `runtime/templates/git/gitconfig_aliases` | Template for Git aliases. |
| `runtime/templates/git/gitignore.global` | Template for global gitignore. |
| `runtime/templates/git/shell_aliases` | Template for shell Git/GitHub shortcuts. |
| `runtime/scripts/clean` | Construction stub for cleanup (phase 1 exits non-zero; no deletions). |
| `runtime/scripts/config` | Construction stub for managed Git configuration refresh. |
| `runtime/scripts/demo` | Phase-1 construction stub demonstrating a numbered menu command module. |
| `runtime/scripts/help` | Help command module for global and per-invocation usage text. |
| `runtime/scripts/setup` | Construction stub for full GitHub/SSH/GPG setup. |
| `runtime/scripts/test` | Construction stub for the integration test operation. |
| `runtime/scripts/verify` | Construction stub for read-only configuration verification. |

## Contributor tooling and editor support

| File | Purpose and reason |
| --- | --- |
| `.commandcode/taste/taste.md` | Lets CommandCode learn repository-specific command preferences for future assistance. |
| `.git-hooks/ravn-shell-quality` | Formats and ShellChecks staged shell files as part of the local quality gate. |
| `.vscode/extensions.json` | Recommends editor extensions so contributors receive the intended language support. |
| `.vscode/settings.json` | Shares VS Code workspace settings that preserve repository formatting behavior. |
| `.vscode/shellcheck.sh` | Adapts ShellCheck invocation for the VS Code task environment. |
| `.vscode/tasks.json` | Defines VS Code tasks for common repository checks and commands. |

## GitHub collaboration and automation

| File | Purpose and reason |
| --- | --- |
| `.github/PULL_REQUEST_TEMPLATE.md` | Prompts pull-request authors for scope, validation, and release-impact information. |
| `.github/ISSUE_TEMPLATE/bug_report.yml` | Collects reproducible bug reports with the context needed to triage them. |
| `.github/ISSUE_TEMPLATE/custom.yml` | Provides a flexible issue form for work outside a specialized template. |
| `.github/ISSUE_TEMPLATE/documentation_update.yml` | Collects documentation requests with the affected audience and material. |
| `.github/ISSUE_TEMPLATE/feature_request.yml` | Collects feature proposals with their problem, outcome, and constraints. |
| `.github/workflows/ci.yml` | Runs the repository verification suite on GitHub before changes are integrated. |
| `.github/workflows/lock.yml` | Locks inactive conversations to keep issue and pull-request discussions manageable. |
| `.github/workflows/release-please.yml` | Lets Release Please prepare releases and publish verified release assets. |

## Product workflow companions (construction examples)

Portable workflow companions under `make/ravn-cli/workflow/` are construction
examples from the template origin. Phase-1 stubs must not install them into the
user bin directory.

| File | Purpose and reason |
| --- | --- |
| `make/ravn-cli/workflow/.git-workflow` | Shared helper sourced by managed workflow companions. |
| `make/ravn-cli/workflow/a` | Portable companion for the `a` workflow surface. |
| `make/ravn-cli/workflow/ac` | Portable companion for the `ac` workflow surface. |
| `make/ravn-cli/workflow/af` | Portable companion for the `af` workflow surface. |
| `make/ravn-cli/workflow/bye` | Portable companion for the `bye` workflow surface. |
| `make/ravn-cli/workflow/c` | Portable companion for the `c` workflow surface. |
| `make/ravn-cli/workflow/clean` | Portable companion for the `clean` workflow surface. |
| `make/ravn-cli/workflow/cm` | Portable companion for the `cm` workflow surface. |
| `make/ravn-cli/workflow/d` | Portable companion for the `d` workflow surface. |
| `make/ravn-cli/workflow/df` | Portable companion for the `df` workflow surface. |
| `make/ravn-cli/workflow/fc` | Portable companion for the `fc` workflow surface. |
| `make/ravn-cli/workflow/fm` | Portable companion for the `fm` workflow surface. |
| `make/ravn-cli/workflow/fuck` | Portable companion for the `fuck` workflow surface. |
| `make/ravn-cli/workflow/l` | Portable companion for the `l` workflow surface. |
| `make/ravn-cli/workflow/lg` | Portable companion for the `lg` workflow surface. |
| `make/ravn-cli/workflow/p` | Portable companion for the `p` workflow surface. |
| `make/ravn-cli/workflow/s` | Portable companion for the `s` workflow surface. |
| `make/ravn-cli/workflow/st` | Portable companion for the `st` workflow surface. |

## Make command modules

| File | Purpose and reason |
| --- | --- |
| `make/aliases.mk` | Supplies short aliases that make the public Make interface faster to use interactively. |
| `make/docker.mk` | Defines Docker build and validation commands so clean-environment checks are repeatable. |
| `make/git.mk` | Defines guided Git commands with the repository's user-facing visual language. |
| `make/hooks.mk` | Installs and checks the local quality-gate hooks required before commits. |
| `make/quality.mk` | Exposes deterministic formatting, linting, and verification commands for contributors and CI. |
| `make/release.mk` | Exposes release diagnostics and GitHub setup commands without handling secrets directly. |

## Architecture and agent references

| File | Purpose and reason |
| --- | --- |
| `docs/adr/0001-pre-commit-framework-as-quality-gate-entrypoint.md` | Records why pre-commit is the sole local quality-gate entrypoint. |
| `docs/adr/0002-quality-gate-escape-hatches.md` | Defines the permitted, auditable ways to bypass quality checks when necessary. |
| `docs/adr/0003-doc-quality-gate-without-docker.md` | Records the decision to lint documentation locally without a Docker dependency. |
| `docs/adr/0004-strict-doc-quality-on-commit-project-scope.md` | Establishes strict documentation checks across the committed project scope. |
| `docs/adr/0005-single-markdownlint-config-file.md` | Records why Markdown linting uses one shared configuration file. |
| `docs/adr/0006-quality-gate-bootstrap.md` | Defines how clones install the quality gate and verify required host tools. |
| `docs/adr/0007-shell-failure-reports-in-worktree-logs.md` | Records why shell-quality failures write diagnostic reports inside each worktree. |
| `docs/adr/0008-no-shell-path-exclusions.md` | Establishes that every staged shell file is subject to the ShellCheck gate. |
| `docs/adr/0009-repository-bootstrap-scope.md` | Defines the safe boundary between local bootstrap and canonical remote configuration. |
| `docs/adr/0010-release-please-managed-lifecycle.md` | Records the Release Please ownership model for versions, changelogs, and releases. |
| `docs/adr/0011-ravn-cli-scaffolded-from-git-setup.md` | Records why ravn-cli is scaffolded from git-setup and evolves independently. |
| `docs/agents/domain.md` | Explains where shared domain vocabulary and architectural decisions are maintained. |
| `docs/agents/issue-tracker.md` | Documents GitHub issue workflow and the metadata agents must maintain. |
| `docs/agents/triage-labels.md` | Defines the common label vocabulary used to classify and route repository work. |
| `docs/make/README.md` | Documents every public Make command, its purpose, and representative use cases. |
| `docs/repository-map.md` | Maps the template's non-test files so new users can understand its construction. |
