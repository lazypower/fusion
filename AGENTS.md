# Agent Instructions

## Communication

- Use English for all documentation and code comments.
- Keep responses concise and actionable.
- Challenge proposals when you have a better alternative.

## Project Context

- Fork of [0x2e/fusion](https://github.com/0x2e/fusion) RSS reader, repackaged on wolfi-base (glibc) via Chainguard's melange/apko toolchain. Upstream alpine/musl has DNS resolution issues.
- Prioritize simplicity and maintainability over complexity.

## Branch Strategy

- **`main`** — tracks upstream. Keep clean for syncing and submitting PRs back.
- **`wolfi-main`** — our working branch. All fork-specific changes go here.

## Build System

Upstream's Dockerfile is replaced by melange + apko:

- **`melange.yaml`** — builds the fusion APK (frontend via pnpm/vite, then static Go binary)
- **`apko.yaml`** — assembles the OCI image (wolfi-base + fusion APK, runs as UID 100/GID 101)
- **`Makefile`** — local workflow: `make keygen` (one-time), `make package`, `make image`, `make push`

Signing keys are ephemeral — generated per build. No persistent keys.

## CI

- **`image.yml`** — melange+apko build, pushes to `ghcr.io/lazypower/fusion` on `wolfi-main` pushes.
- **`test.yml`** / **`frontend.yml`** — kept from upstream for project health (Go tests, i18n checks).
- Upstream `docker.yml` and `release.yml` have been removed.

## Remotes

- **github** — `github.com/lazypower/fusion` (our fork)
- **upstream** — `github.com/0x2e/fusion` (original)

## Code Standards

- Follow best practices without over-engineering.
- Default to no backward-compatibility work unless explicitly requested; if a change may break data formats, public APIs, or migrations, clearly state the impact.
- Write self-explanatory code with clear naming.
- Add comments in English only when they provide non-obvious value:
  - **DO write comments for:**
    - Complex business logic or algorithms
    - Non-obvious design decisions and trade-offs
    - Public APIs, exported functions, and package documentation
    - TODO/FIXME/NOTE markers with context
  - **DON'T write comments for:**
    - Self-evident code (e.g., getters/setters)
    - Repeating what the code already says
    - Implementation details that naming makes clear

## Go Development

- After modifying Go code, run `goimports -w .` before verification.
- Verify compilation with `go build -o /dev/null /path/to/file_or_dir`.
- Run related tests and ensure they pass.
- Use named SQL parameters (e.g., `:param_name` or `@param_name`).

## Frontend Development

- Verify TypeScript/TSX compilation with `npx tsc -b --noEmit`.
- Do not modify shadcn component source files directly.
