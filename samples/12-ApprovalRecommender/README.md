# 12 — Approval Recommender

When the standard BC approval workflow creates an **Approval Entry**, this sample asks the agent for a recommendation (`Approve / Reject / Hold` + reason) and writes it to a related table. The recommendation appears on the Approval Entries page so the human approver sees the agent's opinion alongside the request.

## What this teaches

- BC event subscriber: `OnAfterInsertEvent` of `Approval Entry`
- Writing a sibling record keyed by another record's primary key
- Surfacing a related field on an extending page via `SubPageLink`

## Read order

1. [src/Codeunits/QUAApprovalRecommender.Codeunit.al](src/Codeunits/QUAApprovalRecommender.Codeunit.al) — event subscriber + agent call
2. [src/Tables/QUAApprovalRecommendation.Table.al](src/Tables/QUAApprovalRecommendation.Table.al)
3. [src/PageExtensions/QUAApprovalEntriesExt.PageExt.al](src/PageExtensions/QUAApprovalEntriesExt.PageExt.al)

## Configure

Set **Approval Recommender Agent No.** on Sales & Receivables Setup.
