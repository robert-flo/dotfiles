# Strict Doc Quality Gate on commit, project docs only

We run a **strict** markdownlint profile as part of the commit-time Quality Gate (not a permissive legacy-debt profile). Scope is **first-party project documentation** Git can stage. The Local Agent Tree (`.agents/`, local `skills-lock.json`) is **gitignored**, so skill markdown is not a normal gate input; an explicit pre-commit exclude for `.agents/**` is optional defense in depth, not the primary ownership boundary.

## Considered options

- **Strict on all staged/tracked `*.md` (chosen in practice)** — high bar on product docs; skills stay out via gitignore.
- **Strict only on `docs/**` + root docs via globs** — narrower; unnecessary while `.agents/` is ignored.
- **Lax on commit, strict optional/CI** — easier adoption; weaker local doc guarantee.
- **Dual profiles by path (strict + lax)** — more machinery than needed here.
