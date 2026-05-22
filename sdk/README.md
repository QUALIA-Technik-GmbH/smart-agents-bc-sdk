# Smart Agent SDK (app)

The SDK app. One codeunit, no other objects.

- AL identifier: `Codeunit "QUA Smart Agent SDK"`
- Object ID: `77000`
- App ID: `777ec685-ba60-4c5b-a90b-4ee1c67ed777`
- Range: `77000–77009`

Open [src/Codeunits/QUASmartAgentSDK.Codeunit.al](src/Codeunits/QUASmartAgentSDK.Codeunit.al) for the full API.

## Quick API map

| Area | Procedures |
|---|---|
| Chat UI | `OpenChat`, `OpenChatForAgent`, `OpenChatForRecord` |
| Sync send | `SendMessageAndPoll`, `SendMessageAndPollInSession` |
| Async send | `SendMessage`, `SendMessageInSession`, `Poll` |
| Tool calls | `ApproveAllToolCalls`, `RejectAllToolCalls` |
| Agent CRUD | `CreateAgent`, `UpdateAgent`, `SetAgentCapabilities`, `SetAgentAutonomy`, `AddDataSource`, `AddToolLink`, `AddAuthorizedUser`, `ActivateAgent`, `DeactivateAgent`, `SyncAgentToBackend`, `DeleteAgent` |
| Lookup | `LookupAgent`, `ValidateAgentNo`, `GetAgentName`, `DrillDownAgent`, `GetAgent`, `ListAgents` |
| Result parsing | `GetStatus`, `GetResponse`, `GetToolCalls`, `GetCreditsUsed`, `GetTokensUsed`, `GetPromptTokens`, `GetCompletionTokens`, `GetSessionId` |
| Health | `IsSmartAgentsInstalled` |

See the top-of-file comment block for working snippets.
