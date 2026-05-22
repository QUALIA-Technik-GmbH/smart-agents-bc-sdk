# Security Policy

## Reporting a vulnerability

Please **do not** open a public issue for security problems.

Email **security@qualia-technik.de** with:

- A description of the issue
- The affected SDK version (and Smart Agents app version if relevant)
- Steps to reproduce, ideally with a minimal AL snippet
- Whether you've shared it with anyone else

We aim to acknowledge within 2 business days and provide a remediation timeline within 10 business days.

## Scope

In scope:

- The `QUA Smart Agent SDK` codeunit and its public procedures
- Any sample under `samples/` shipped from this repository
- Documentation that leads developers to insecure patterns

Out of scope:

- Vulnerabilities in the Smart Agents app itself — report those through the channel published in that app's own documentation
- Vulnerabilities in Microsoft Dynamics 365 Business Central — report to Microsoft via MSRC
- Vulnerabilities in third-party AL apps that consume this SDK

## Disclosure

We follow coordinated disclosure. Once a fix is available, we publish:

- A patched SDK version
- A `SECURITY-NN.md` advisory in this repo
- A note in [CHANGELOG.md](CHANGELOG.md)

We credit reporters by name unless requested otherwise.
