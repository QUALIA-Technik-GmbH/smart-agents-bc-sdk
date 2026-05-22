# 02 — Record Insights

A **FactBox** on the Customer Card that shows AI-generated insights, fetched **asynchronously** so the page never freezes.

## What this teaches

- The async pattern: `SendMessage` → `Poll` in a loop
- Wrapping the loop so the calling UI doesn't block the user
- A FactBox with a single body field as a lightweight AI surface

## Flow

```
Customer Card opens
    └─ FactBox.OnAfterGetCurrRecord
         ├─ Show "Generating insights…"
         └─ Runner.RunAsync(customer)
              ├─ SendMessage(agent, "Summarize this customer …")    ← returns RequestId immediately
              └─ Poll until status = 'completed' (every 1.5 s, cap 30 attempts)
                  └─ FactBox displays the response
```

## Configure

Set **Record Insights Agent No.** on **Sales & Receivables Setup** (the field is added by this app). Use the existing **QUA Email Draft** agent or provision a new one (any agent with BC data access works).

## Read order

1. [src/Pages/QUARecordInsightsFactBox.Page.al](src/Pages/QUARecordInsightsFactBox.Page.al) — the FactBox
2. [src/Codeunits/QUARecordInsightsRunner.Codeunit.al](src/Codeunits/QUARecordInsightsRunner.Codeunit.al) — the async loop
3. [src/PageExtensions/QUACustomerCardInsightsExt.PageExt.al](src/PageExtensions/QUACustomerCardInsightsExt.PageExt.al) — wires the FactBox in
