# No transitional shell path exclusions

The Shell Quality Gate does **not** skip paths via a transitional exclusion list. Every staged shell file (`*.sh` or shell shebang) is formatted and linted. Legacy allowlists (uwsm, waybar, wallbash, selected `Scripts/*`, etc.) are removed from the gate contract so debt cannot hide behind the hook.

The Local Agent Tree under `.agents/` is gitignored, so skill scripts are not staged in normal workflows and do not require gate-level excludes. Force-adding ignored files would subject them to the gate — acceptable.

Consequence: bringing large unlinted **tracked** shell trees into this repository requires fixing or deliberately using Selective Hook Skip / Full Gate Bypass — not silent excludes.

## Considered options

- **Hardcoded excludes in the script** — SSOT but preserves debt.
- **External exclude file** — easier edits; still an allowlist of silence.
- **No path exclusions (chosen)** — honest gate; may block commits that touch dirty legacy shell.
- **pre-commit `exclude:` only** — poor fit for shebang detection and local-hook design.
