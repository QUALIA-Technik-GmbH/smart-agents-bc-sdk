# Contributing

Thanks for your interest in improving the Smart Agents BC SDK.

## Where to start

- **Bug?** Open an issue with a minimal reproduction (sample number, AL snippet, expected vs. actual).
- **New sample?** Open an issue first to discuss the pattern — we want each sample to teach one distinct BC integration pattern, not duplicate an existing one.
- **Doc fix?** PR directly.

## Local setup

1. Install AL Language for VS Code.
2. Clone the repo.
3. Open `sdk/` or any `samples/0X-*/` folder as a workspace.
4. Download symbols (`AL: Download Symbols`) against a BC sandbox that has the Smart Agents app installed.
5. Press F5 to publish.

## Coding conventions

- Object name prefix: `QUA`.
- Object IDs: stay inside the allocation in [README.md](README.md). Each sample owns 20 IDs.
- Labels: every user-facing string must be a `Label` with `Comment = '...'` describing the placeholders.
- Error handling: surface backend errors through the SDK's `ErrorText` out-parameter, never via raw `Error()` with concatenated strings.
- Analyzers: `CodeCop`, `UICop`, `AppSourceCop`, `PerTenantExtensionCop` must all pass cleanly. Each app's `.vscode/settings.json` ships with them enabled.
- Commits: imperative mood, ≤72 chars in the subject. Reference the sample number when applicable: `01-EmailDraft: fix missing ToList`.

## Adding a sample

A new sample must:

1. Live in `samples/NN-Name/`, with its own `app.json` and `README.md`.
2. Use a sample-specific object range from the reserved block in [README.md](README.md).
3. Show **one** clearly identified pattern that no other sample shows.
4. Stay under 5 AL files where reasonable.
5. Update the top-level [README.md](README.md) pattern table and [CHANGELOG.md](CHANGELOG.md).

## Releases

- Versions follow SemVer. The major version bumps when the Smart Agents compatibility matrix breaks.
- Compiled `.app` artifacts are attached to GitHub Releases — they are not committed to the source tree.
