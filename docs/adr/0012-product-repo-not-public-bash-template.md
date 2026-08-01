# This monorepo is RaVN Dotfiles product, not a public Bash template

This repository is the rewrite of the maintainer's Arch Linux dotfiles and
tooling (**RaVN Dotfiles**). It will no longer present or enforce a generic
"Bash project template" / "Use this template" public contract.

We remove the public-template documentation test contract (and its ban on
product names such as `ravn` in first-party public docs), rewrite public
surfaces for product voice, and keep a renamed fresh-repo acceptance harness
that still validates release, bootstrap, and aggregate verify—without the
template identity assertions. First delivery is identity, docs, and contract
tests only; monorepo Hello World Docker remains until a later change.

## Considered options

- **Stay a dual template+product repo** — rejected; fights README, CI, and the
  rewrite goal.
- **Move the generic template to a sibling repo** — optional later; not required
  for this decision.
- **Docs-only rename without killing template tests** — rejected; leaves
  `make verify` enforcing the wrong identity.

## Consequences

- `tests/public-template-docs.sh` and template-only acceptance steps go away or
  become product-docs assertions under new names.
- Public docs and GitHub description must name RaVN Dotfiles; GitHub template
  mode stays off.
- Agents must not reintroduce "Customize before publishing" as the onboarding
  story for this repository.
