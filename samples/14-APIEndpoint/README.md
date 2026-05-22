# 14 — API Endpoint

Exposes a Smart Agent to **external callers** (Power Automate, custom apps, integration platforms) through a standard BC REST API page.

## What this teaches

- `PageType = API` and how to bind it to a temp table
- Receiving JSON-shaped requests via OData and returning the agent's reply
- Audit-logging external calls

## Endpoint

After publishing the app, the endpoint lives at:

```
POST https://api.businesscentral.dynamics.com/v2.0/{tenant}/{env}/api/qualiaTechnik/agentBridge/v1.0/companies({companyId})/askAgent
```

Body:

```json
{
  "agentNo": 1,
  "prompt": "List the 3 customers with the highest balance."
}
```

Response:

```json
{
  "agentNo": 1,
  "status": "completed",
  "response": "…",
  "tokensUsed": 234,
  "errorText": ""
}
```

## Power Automate

Add the endpoint as a **Custom Connector** action; pass `agentNo` and `prompt` in the request body; map `response` to the next step.

## Read order

1. [src/Pages/QUAAskAgentAPI.Page.al](src/Pages/QUAAskAgentAPI.Page.al) — the API page
2. [src/Tables/QUAAskAgentBuffer.Table.al](src/Tables/QUAAskAgentBuffer.Table.al) — temp source table
3. [src/Codeunits/QUAFlowAgentBridge.Codeunit.al](src/Codeunits/QUAFlowAgentBridge.Codeunit.al) — request → SDK → response

## Security

The endpoint inherits BC's standard OAuth flow. Any caller that can authenticate to BC and hold the `QUA API Endpoint` permission set can invoke the agent. Audit each invocation in [src/Tables/QUAFlowAgentCallLog.Table.al](src/Tables/QUAFlowAgentCallLog.Table.al).
