# 06 — Write Approval

A prompt page where the user instructs an agent to **write** something. When the agent reaches `awaiting_confirmation`, the page lists the proposed tool calls and offers **Approve** / **Reject** actions.

## What this teaches

- The async pattern combined with `awaiting_confirmation` status detection
- Calling `ApproveAllToolCalls` and `RejectAllToolCalls` from the SDK
- Reading `GetToolCalls` to display what the agent wants to do *before* it acts

## Flow

```
User opens "Agent Write Approval" page
   └─ Types prompt, e.g. "Block customer C00010 with reason 'Compliance'"
        ├─ SA.SendMessage(agent, prompt) → requestId
        └─ Poll loop until status = 'awaiting_confirmation'
             ├─ Render toolCalls in a repeater
             ├─ user clicks Approve  → SA.ApproveAllToolCalls(requestId)
             │     └─ continue polling until status = 'completed'
             └─ user clicks Reject   → SA.RejectAllToolCalls(requestId)
```

## Configure

Set **Write Approval Agent No.** on **Sales & Receivables Setup** to an agent with **BC Data Access** capability enabled.

## Read order

1. [src/Pages/QUAWriteApproval.Page.al](src/Pages/QUAWriteApproval.Page.al)
2. [src/Codeunits/QUAToolCallReviewer.Codeunit.al](src/Codeunits/QUAToolCallReviewer.Codeunit.al)
