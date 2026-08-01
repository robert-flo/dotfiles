# repository bootstrap separates local and remote setup

The repository has two setup concerns with different authority requirements:
installing the local Quality Gate in a clone, and administering the canonical
GitHub repository. Combining them unconditionally makes normal contributor
onboarding require repository-administrator access and can mutate a fork.

`make repository-bootstrap` is the local interface. It verifies the required
tools and installs the pre-commit Entrypoint. Maintainers opt into remote
administration with `CONFIGURE_REMOTE=1`; that synchronizes the release
lifecycle labels and replaces default-branch protection with the documented
policy.
Replacing branch protection also requires the internal
`GIT_REPLACE_PROTECTION=1` acknowledgement, supplied only by the maintainer
path.

## Considered options

- **Local default plus explicit remote opt-in (chosen)** — one memorable
  command with a safe default, while clone automation can opt into the
  maintainer path deliberately.
- **Always configure remote state** — convenient for one repository, unsafe
  for forks and contributors without administrator access.
- **Separate unrelated commands only** — safe but makes required setup easy to
  forget and hides the relationship between hooks, labels, and protection.
