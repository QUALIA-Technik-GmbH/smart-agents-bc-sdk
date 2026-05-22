# 07 — Test Harness

How to write AL tests for SDK-backed features **without calling the real Smart Agents backend**.

## What this teaches

- The mock facade pattern: write a row into the buffer table with `Is Processed = true` and a canned response *before* the SDK's `Codeunit.Run` fires. The facade codeunit sees an already-processed row and returns immediately.
- Why the SDK is testable: it talks to the upstream app only through the buffer table.

## Read order

1. [src/Codeunits/QUASmartAgentMockFacade.Codeunit.al](src/Codeunits/QUASmartAgentMockFacade.Codeunit.al) — the mock
2. [src/Codeunits/QUASdkTests.Codeunit.al](src/Codeunits/QUASdkTests.Codeunit.al) — the [Test] codeunit

## Limitations

- Some SDK procedures (`OpenChat`, `OpenChatForRecord`) call `Page.Run`. Mock those by separating the orchestration code from the SDK call so the page run isn't on the test path.
- The mock is **best-effort**. It demonstrates the technique; a production test app may want a richer queue of canned responses.
