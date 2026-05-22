# 10 — Journal Builder

User pastes `Office supplies €234.50 paid by credit card on 2026-03-12` → agent returns a JSON array → the codeunit creates the matching **General Journal lines** in the active batch.

## What this teaches

- Multi-record structured fill (vs. the single-record 09 Smart Field Fill)
- Iterating a JSON array of objects and inserting one record per element
- Targeting an existing Journal Batch + Template by name from a setup record

## Read order

1. [src/Pages/QUAJournalBuilderPrompt.Page.al](src/Pages/QUAJournalBuilderPrompt.Page.al) — PromptDialog
2. [src/Codeunits/QUAJournalLineBuilder.Codeunit.al](src/Codeunits/QUAJournalLineBuilder.Codeunit.al) — JSON → lines
3. [src/PageExtensions/QUAGenJnlBuilderExt.PageExt.al](src/PageExtensions/QUAGenJnlBuilderExt.PageExt.al) — adds the action

## Configure

On **Sales & Receivables Setup** (also used for journal config in this sample) set:

- **Journal Builder Agent No.** — the agent
- **Journal Template Name** — e.g. `GENERAL`
- **Journal Batch Name** — e.g. `DEFAULT`
