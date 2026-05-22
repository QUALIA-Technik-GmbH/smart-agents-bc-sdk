# Recommended GitHub repo configuration

For maximum discoverability in GitHub and Google search, configure the repo with the values below.

## About section

Set in: **Repo page → ⚙️ next to "About"**

**Description**

```
AL SDK and 14 sample apps for building AI agents in Microsoft Dynamics 365 Business Central (D365 BC) on top of Smart Agents — a Copilot-class AI platform for ERP. MIT licensed, zero compile-time dependency.
```

**Website**

```
https://smart.agent.net.ai
```

## Topics

Set via the **About → ⚙️ → Topics** UI, or run this one-liner with the [GitHub CLI](https://cli.github.com/) from the repo root:

```bash
gh repo edit --add-topic business-central \
             --add-topic d365-business-central \
             --add-topic microsoft-dynamics-365 \
             --add-topic dynamics-365 \
             --add-topic msdyn365bc \
             --add-topic al-language \
             --add-topic al-extension \
             --add-topic bc-extension \
             --add-topic appsource \
             --add-topic ai \
             --add-topic artificial-intelligence \
             --add-topic llm \
             --add-topic generative-ai \
             --add-topic agentic-ai \
             --add-topic ai-agents \
             --add-topic smart-agents \
             --add-topic copilot \
             --add-topic business-ai \
             --add-topic erp-ai \
             --add-topic ai-for-business \
             --add-topic sdk \
             --add-topic sample-code \
             --add-topic sample-apps
```

PowerShell users on Windows can paste the same command — `gh` reads backslashes as line continuations in bash, but in PowerShell drop the backslashes and run it as one line, or use the `--%` stop-parsing token if you keep them.

## Social preview image

GitHub uses an Open Graph image when the repo URL is shared on Twitter / LinkedIn / etc. Upload a 1280×640 PNG at:

**Repo → Settings → Social preview → Upload an image**

The repository ships with [Smart_Agents_Logo.png](../Smart_Agents_Logo.png) at the root. Either upload it as-is if it already meets 1280×640, or use it as the logo element on a banner of that size with the headline "Smart Agents BC SDK — AI for Microsoft Dynamics 365 Business Central" and an MIT badge.

## Releases vs. source tree

- Compiled `.app` files for the SDK and each sample go on **Releases** as attachments.
- The source tree should never contain `.app`, `.alpackages/`, `.altestrunner/`, or `.vscode/.alcache/` — `.gitignore` already excludes them.

## Issue and PR templates

Optional but improves engagement. To add later:

```
.github/ISSUE_TEMPLATE/bug_report.md
.github/ISSUE_TEMPLATE/feature_request.md
.github/PULL_REQUEST_TEMPLATE.md
```

## Branch protection (recommended once contributors arrive)

- Require pull request reviews before merging to `main`.
- Require status checks to pass (once a CI workflow exists).
- Restrict force pushes to `main`.
