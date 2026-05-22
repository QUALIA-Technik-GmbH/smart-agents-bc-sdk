## Summary

<!-- One or two sentences: what changes and why. -->

## Scope

- [ ] `sdk/` — the `QUA Smart Agent SDK` codeunit
- [ ] Sample: `__`
- [ ] Documentation only (README, CONTRIBUTING, repo-config, etc.)
- [ ] Tooling (`.github/`, `.gitignore`, etc.)

## Change type

- [ ] Bug fix (no API change)
- [ ] New feature (additive, no breaking change)
- [ ] Breaking change (signature, semantics, or compatibility matrix changes)
- [ ] Refactor / cleanup
- [ ] Documentation

## How I tested

<!-- Tick all that apply and add detail where useful. -->

- [ ] Built locally with AL Language extension
- [ ] Published to a BC sandbox and exercised the affected sample manually
- [ ] Ran `samples/07-TestHarness` tests (or added a new one)
- [ ] No build needed (docs / tooling only)

Steps:

<!-- e.g. "Opened Customer C00010, clicked Draft Email, confirmed the editor opened with the customer's email pre-filled." -->

## Compatibility checklist

- [ ] No upstream Smart Agents object IDs were changed
- [ ] Object IDs stay inside the per-sample range documented in `README.md`
- [ ] Every new user-facing string is a `Label` with `Comment = '...'`
- [ ] CodeCop / UICop / AppSourceCop / PerTenantExtensionCop pass clean
- [ ] `CHANGELOG.md` updated (or change is too small to warrant an entry)

## Related issues

<!-- Closes #123 / refs #456 -->

## Anything reviewers should know

<!-- Surprising trade-offs, follow-up work intentionally deferred, screenshots, etc. -->
