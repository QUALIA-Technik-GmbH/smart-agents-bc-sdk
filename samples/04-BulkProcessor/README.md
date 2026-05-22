# 04 — Bulk Processor

A **Job Queue** background job that asks a Smart Agent one question per customer and stores each answer in a results table.

## What this teaches

- Hooking the SDK into a `Job Queue Entry` (codeunit must accept the standard `OnRun` signature)
- Why blocking `SendMessageAndPoll` is acceptable in a background job (no UI thread to freeze)
- Persisting results for human review instead of acting on them automatically
- A clean separation between the orchestrator (the runnable codeunit) and the per-record worker

## Flow

```
Job Queue Entry fires every N minutes
    └─ Codeunit "QUA Bulk Processor Job".OnRun()
         ├─ Read Setup: which agent, which filter, which prompt template
         └─ For each Customer matching filter:
              ├─ Codeunit "QUA Bulk Processor Runner".ProcessOne(Customer)
              │     └─ SA.SendMessageAndPoll(agent, prompt, err)
              └─ Insert row in "QUA Bulk Processor Result"
```

## Configure

1. Open **Bulk Processor Setup** (search the page).
2. Pick the **Agent No.**, set the **Customer Filter**, write a **Prompt Template** (use `%1` and `%2` for No./Name).
3. Schedule the codeunit `QUA Bulk Processor Job` via standard **Job Queue Entries**.

## View results

Search **Bulk Processor Results** — one row per processed customer with status, response excerpt, tokens.

## Read order

1. [src/Tables/QUABulkProcessorResult.Table.al](src/Tables/QUABulkProcessorResult.Table.al)
2. [src/Codeunits/QUABulkProcessorRunner.Codeunit.al](src/Codeunits/QUABulkProcessorRunner.Codeunit.al)
3. [src/Codeunits/QUABulkProcessorJob.Codeunit.al](src/Codeunits/QUABulkProcessorJob.Codeunit.al)
4. [src/Pages/QUABulkProcessorSetup.Page.al](src/Pages/QUABulkProcessorSetup.Page.al)
