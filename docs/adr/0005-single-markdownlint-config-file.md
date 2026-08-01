# Single markdownlint config file

Commit policy is the Strict Doc Profile. To avoid auto-discovery picking a permissive twin, the repository keeps **one** markdownlint config at the conventional path `.markdownlint.yaml` (content = strict project rules). Duplicate `.markdownlint.json` and `.markdownlint-strict.yaml` are not kept as live alternate commit policies.

## Considered options

- **One canonical `.markdownlint.yaml` (chosen)** — discovery matches commit policy.
- **Strict file + explicit `--config`** — easy to mis-run the CLI against a leftover lax default.
- **Keep lax + strict files** — guaranteed drift.
