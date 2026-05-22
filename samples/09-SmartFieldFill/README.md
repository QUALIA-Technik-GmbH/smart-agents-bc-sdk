# 09 — Smart Field Fill

User types `5 boxes of A4 paper` in a Sales Line Description → clicks **Auto-Fill** → the agent returns structured JSON → the line gets the right `Item No.` and `Quantity`.

## What this teaches

- Asking the agent for **structured output** (a JSON blob) and parsing it
- Validating fields back into a record via `Rec.Validate`
- A pattern that scales to many "free-text → record" workflows

## Read order

1. [src/Codeunits/QUASmartFillEngine.Codeunit.al](src/Codeunits/QUASmartFillEngine.Codeunit.al) — prompt + JSON parse
2. [src/PageExtensions/QUASalesLineSmartFillExt.PageExt.al](src/PageExtensions/QUASalesLineSmartFillExt.PageExt.al) — adds the action

## Configure

Set **Smart Fill Agent No.** on **Sales & Receivables Setup** to an agent instructed to reply with JSON of the form `{"itemNo":"...","quantity":N}`.
