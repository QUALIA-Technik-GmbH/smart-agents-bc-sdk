# 11 — Anomaly Watcher

A scheduled scan that asks the agent *"flag anything unusual in recent G/L entries"* and writes findings to a list page for humans to review.

## What this teaches

- Combining the Bulk Processor pattern with a JSON-array response
- A monitoring/dashboard UX (vs. the user-triggered Q&A in earlier samples)
- Pull-style integration: the agent decides what to surface, not the user

## Read order

1. [src/Tables/QUAAnomalyFinding.Table.al](src/Tables/QUAAnomalyFinding.Table.al)
2. [src/Codeunits/QUAAnomalyWatcherJob.Codeunit.al](src/Codeunits/QUAAnomalyWatcherJob.Codeunit.al)
3. [src/Pages/QUAAnomalyFindings.Page.al](src/Pages/QUAAnomalyFindings.Page.al)

## Configure

Set **Anomaly Agent No.** on Sales & Receivables Setup. Schedule the codeunit **QUA Anomaly Watcher Job** in **Job Queue Entries** (e.g. nightly).
