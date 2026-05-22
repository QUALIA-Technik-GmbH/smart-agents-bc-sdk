# 05 — Conversation Sidebar

A multi-turn AI chat embedded **inside the Customer Card** as a page part. Each user message keeps the same session, so the agent remembers earlier turns.

## What this teaches

- `SendMessageAndPollInSession` for multi-turn conversations
- Holding session state on the page using `GetSessionId` after the first reply
- Rendering turns from a temp record in a repeater

## Read order

1. [src/Tables/QUAConversationTurn.Table.al](src/Tables/QUAConversationTurn.Table.al) — temp record for turns
2. [src/Pages/QUAConversationSidebar.Page.al](src/Pages/QUAConversationSidebar.Page.al) — the sidebar
3. [src/PageExtensions/QUACustomerCardSidebarExt.PageExt.al](src/PageExtensions/QUACustomerCardSidebarExt.PageExt.al) — wires it in
