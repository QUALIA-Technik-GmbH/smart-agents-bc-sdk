# 01 — Email Draft

A **PromptDialog** on the Customer Card that drafts an email using a Smart Agent.

## What this teaches

- The simplest synchronous integration: `SendMessageAndPoll` with a 120 s timeout
- How to feed record context into a prompt without exposing it via a chat UI
- Plugging the result into BC's `Codeunit Email` editor
- Storing a "which agent to use" reference on a Setup table

## Flow

```
Customer Card → "Draft Email" action
              → PromptDialog (user types intent)
              → SendMessageAndPoll(agent, "Customer No.=… In the context of…  + user prompt")
              → Email.OpenInEditor(EmailMessage)
```

## Install

1. Make sure the Smart Agents app and the Smart Agent SDK app are installed.
2. Publish this app (F5).
3. Open **Sales & Receivables Setup** → click **Create Email Draft Smart Agent** (one-click provisioning), or pick an existing agent in the **Smart Agent No.** field.
4. Open any Customer Card → click **Draft Email**.

## Read order

1. [src/Pages/QUAEmailDraftPrompt.Page.al](src/Pages/QUAEmailDraftPrompt.Page.al) — the PromptDialog
2. [src/PageExtensions/QUACustomerCardExt.PageExt.al](src/PageExtensions/QUACustomerCardExt.PageExt.al) — the action
3. [src/PageExtensions/QUASalesRcvSetupExt.PageExt.al](src/PageExtensions/QUASalesRcvSetupExt.PageExt.al) — one-click agent provisioning
