# 03 — Card Chat

The simplest possible AI integration: one action on a card → opens the Smart Agent chat **scoped to the current record**. Same pattern, three different cards (Item, Vendor, Sales Quote).

## What this teaches

- `OpenChatForRecord(AgentNo, Rec.RecordId)` — the one-liner that does everything
- How the same SDK call works on any card with no record-specific code
- Storing a single "Card Chat Agent No." on a Setup table

## Read order

1. [src/PageExtensions/QUAItemCardChatExt.PageExt.al](src/PageExtensions/QUAItemCardChatExt.PageExt.al) — the action (same pattern in the other two)
2. [src/PageExtensions/QUAVendorCardChatExt.PageExt.al](src/PageExtensions/QUAVendorCardChatExt.PageExt.al)
3. [src/PageExtensions/QUASalesQuoteChatExt.PageExt.al](src/PageExtensions/QUASalesQuoteChatExt.PageExt.al)

## Configure

Set **Card Chat Agent No.** on **Sales & Receivables Setup** (field added by this app).
