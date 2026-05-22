# 13 — Agent Provisioner

One-click provisioning of a fully configured "Sales Assistant" agent: created in Draft, configured with data sources, tool links, capabilities, an authorized user, then activated.

## What this teaches

- The full agent-management API in a single codeunit
- Idiomatic error handling when one step of a multi-step provisioning fails
- A pattern ISVs can use to ship pre-baked agents alongside their app

## Read order

1. [src/Codeunits/QUAAgentProvisioner.Codeunit.al](src/Codeunits/QUAAgentProvisioner.Codeunit.al) — the entire orchestration
2. [src/Pages/QUAAgentProvisionerPage.Page.al](src/Pages/QUAAgentProvisionerPage.Page.al) — the action page
