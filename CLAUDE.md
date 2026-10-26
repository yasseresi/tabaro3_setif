# CLAUDE.md — Tabaro3 Sétif (CWTS Sétif Blood Donor Desktop App)

See [`AGENTS.md`](AGENTS.md) for the complete project instructions, architectural decisions, commands, and links to `docs/`.

## Quick Summary
- **Stack**: Flutter Desktop (Windows `.exe`/`.msi` target via GitHub Actions; developed on macOS) + **Drift** (local SQLite).
- **Architecture**: Simple Feature-First (`lib/core/`, `lib/data/`, `lib/features/`) — no `dio`/`retrofit`/`dartz`/`rxdart` ceremony.
- **Languages**: Arabic (`ar`, RTL default, `Cairo` font) & French (`fr`, LTR).
- **Core Docs**:
  - [`docs/UI_AND_DOMAIN_SPEC.md`](docs/UI_AND_DOMAIN_SPEC.md)
  - [`docs/STACK.md`](docs/STACK.md)
  - [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
  - [`docs/SKILLS.md`](docs/SKILLS.md)
  - [`docs/BEST_PRACTICES.md`](docs/BEST_PRACTICES.md)
  - [`docs/WHAT_TO_AVOID.md`](docs/WHAT_TO_AVOID.md)
  - [`docs/RELEASE_AND_VERSIONING.md`](docs/RELEASE_AND_VERSIONING.md)
