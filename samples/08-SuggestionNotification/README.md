# 08 — Suggestion Notification

When a user opens a **Sales Order**, the agent is asked for a one-line suggestion (e.g. *"This customer has 3 overdue invoices — consider holding the order"*). If the agent has something to say, BC's **Notification** API surfaces it as a yellow bar with an action.

## What this teaches

- `Notification.Message`, `Notification.AddAction`, `Notification.Send`
- Pairing async polling with a fire-and-forget UX (the page is interactive while the agent thinks)
- Returning early when the agent has nothing to suggest

## Read order

1. [src/Codeunits/QUASuggestionRunner.Codeunit.al](src/Codeunits/QUASuggestionRunner.Codeunit.al)
2. [src/PageExtensions/QUASalesOrderNotifyExt.PageExt.al](src/PageExtensions/QUASalesOrderNotifyExt.PageExt.al)

## Configure

Set **Suggestion Agent No.** on **Sales & Receivables Setup** to an agent prompted to return a short one-line suggestion or the literal word `NONE`.
