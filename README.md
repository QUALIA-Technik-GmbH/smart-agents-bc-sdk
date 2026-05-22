<p align="center">
  <img src="Smart_Agents_Logo.png" alt="Smart Agents" width="220" />
</p>

# Smart Agents BC SDK — AI for Microsoft Dynamics 365 Business Central

> **Build AI agents and AI-powered features for Microsoft Dynamics 365 Business Central (D365 BC) in AL — production-ready SDK, 14 ready-to-use sample apps, zero compile-time dependencies, MIT-licensed.**

🌐 **Website:** [smart.agent.net.ai](https://smart.agent.net.ai)

`Business Central` · `D365 BC` · `Smart Agents` · `AI for business` · `Microsoft Copilot alternative` · `AL extension` · `AppSource` · `LLM` · `Generative AI` · `Agentic AI` · `ERP automation`

---

## What this is

The **Smart Agents BC SDK** is an open-source toolkit that lets any Microsoft Dynamics 365 Business Central partner or developer build AI features — chat, drafting, classification, anomaly detection, approval recommendations, conversational workflows — on top of the **Smart Agents for D365 Business Central** platform, **without taking a compile-time dependency on the Smart Agents app**.

If you've been looking for:

- **AI agents in Business Central** that you can configure, deploy, and ship in your own AL apps
- An **alternative or complement to Microsoft Copilot for Dynamics 365** that works on your terms, with your own backend, on your own roadmap
- A **D365 Business Central AI sample repository** to learn agentic patterns (PromptDialog, FactBox, Job Queue, workflow subscribers, API endpoints, multi-turn chat)
- An **AppSource-ready AI starting point** for ISVs and partners building **Business Central AI apps**

…this repository gives you the SDK, the patterns, and the working code.

---

## Why an SDK on top of Smart Agents?

Smart Agents for D365 Business Central is a standalone AI platform — its own backend, its own LLM orchestration, its own tool-calling, its own audit log. It is **not** built on BC's Copilot Capability framework or BC's in-box Azure OpenAI codeunits; it is a partner-managed AI platform that runs alongside Microsoft Copilot.

This SDK makes Smart Agents **directly callable from any AL extension** through a tiny codeunit (~830 lines, single file). You get:

- **`SendMessageAndPoll`** — one-line synchronous prompt
- **`SendMessage` + `Poll`** — async pattern for UI that mustn't freeze
- **`OpenChatForRecord`** — open the agent chat scoped to any BC record
- **Full agent CRUD** — `CreateAgent`, `AddDataSource`, `AddToolLink`, `AddAuthorizedUser`, `ActivateAgent`, …
- **Tool-call confirmation** — `ApproveAllToolCalls`, `RejectAllToolCalls` for human-in-the-loop writes
- **Telemetry** — `Session.LogMessage` on every call, scoped to your Application Insights

---

## Repository contents

```
smart-agents-bc-sdk/
├── sdk/                  The SDK app — one AL codeunit, no other objects
└── samples/              14 ready-to-install AI pattern samples
```

### The 14 sample patterns

Each sample is a standalone AL app demonstrating one BC integration pattern with a Smart Agent. Install only the ones you want.

| # | Sample | What it shows | BC pattern |
|---|---|---|---|
| 01 | [Email Draft](samples/01-EmailDraft/) | PromptDialog → blocking call → BC Email Editor | PromptDialog action on Customer Card |
| 02 | [Record Insights](samples/02-RecordInsights/) | AI summary on a card without freezing the UI | FactBox + async poll |
| 03 | [Card Chat](samples/03-CardChat/) | One-line "Ask AI" action on any card | `OpenChatForRecord` |
| 04 | [Bulk Processor](samples/04-BulkProcessor/) | Background AI over many records | Job Queue iteration |
| 05 | [Conversation Sidebar](samples/05-ConversationSidebar/) | Embedded multi-turn AI chat | Page part + `SendMessageInSession` |
| 06 | [Write Approval](samples/06-WriteApproval/) | Human approves agent write actions | Tool-call Approve/Reject |
| 07 | [Test Harness](samples/07-TestHarness/) | Deterministic AL tests of AI features | Test codeunit + mock facade |
| 08 | [Suggestion Notification](samples/08-SuggestionNotification/) | Non-blocking AI suggestion on document open | BC Notification API + async agent |
| 09 | [Smart Field Fill](samples/09-SmartFieldFill/) | Free-text → fills `Item No.` + `Quantity` | Action on Sales Line |
| 10 | [Journal Builder](samples/10-JournalBuilder/) | Free-text → multi-row General Journal lines | PromptDialog + structured JSON parsing |
| 11 | [Anomaly Watcher](samples/11-AnomalyWatcher/) | Scheduled AI scan posts findings | Job Queue + dashboard list page |
| 12 | [Approval Recommender](samples/12-ApprovalRecommender/) | AI recommends Approve/Reject on workflow requests | BC Workflow event subscriber |
| 13 | [Agent Provisioner](samples/13-AgentProvisioner/) | One-click provisioning of a configured agent | Full agent CRUD API |
| 14 | [API Endpoint](samples/14-APIEndpoint/) | REST endpoint for Power Automate / external callers | `PageType = API` |

---

## Quick start

### 1. Add the SDK to your project

Either install the compiled `Smart Agent SDK.app` from [Releases](../../releases), or copy [sdk/src/Codeunits/QUASmartAgentSDK.Codeunit.al](sdk/src/Codeunits/QUASmartAgentSDK.Codeunit.al) into your AL project and renumber to a free ID in your range.

### 2. Send your first message

```al
var
    SA: Codeunit "QUA Smart Agent SDK";
    Result: JsonObject;
    Err: Text;
begin
    Result := SA.SendMessageAndPoll(1, 'List my top 5 customers', Err);
    if Err = '' then
        Message(SA.GetResponse(Result));
end;
```

### 3. Open the chat scoped to the current record

```al
SA.OpenChatForRecord(AgentNo, Rec.RecordId);
```

### 4. Provision an agent programmatically

```al
AgentNo := SA.CreateAgent('Sales Assistant', 'Drafts emails', 'Fast',
                          'You are a helpful BC assistant.', Err);
SA.SetAgentCapabilities(AgentNo, true, false, false, false, Err);
SA.AddDataSource(AgentNo, 'Customers', 'Default', '', Err);
SA.ActivateAgent(AgentNo, Err);
```

---

## Where this fits in the Business Central AI ecosystem

| Platform | Backend | Surfaced as | Best for |
|---|---|---|---|
| **Microsoft Copilot in BC** | Microsoft Azure OpenAI Service | "Copilot & AI Capabilities" admin page | Microsoft's own AI features (sales line description suggestions, marketing text, bank rec assist) |
| **BC `AOAI` codeunits + Copilot Capability** | Tenant-managed Azure OpenAI | Custom Copilot Capability features | Partner apps that want to ride the Microsoft AI consent flow |
| **Smart Agents + this SDK** | Smart Agents own backend (partner-managed) | Your own AL pages and actions | Partner-managed AI agents with custom tool calls, audit, and pricing — independent of Microsoft's Copilot roadmap |

---

## Requirements

- Microsoft Dynamics 365 Business Central **v28.0** or later (runtime 17.0+)
- **Smart Agents for D365 Business Central** installed in the tenant
- The calling user holds `SA USER QUA` (or `SA ADMIN QUA`) permission

---

## Object range

The SDK and all samples use the **`77000–77299`** range. If that conflicts with your publisher allocation, renumber before publishing your derivative.

| Range | Used for |
|---|---|
| 77000–77009 | SDK |
| 77010–77289 | Samples (20 IDs each) |
| 77290–77299 | Reserved |

---

## Important caveats

- **`Commit()` inside every facade call.** Do not invoke `SendMessageAndPoll` from inside a transaction whose changes must remain rollback-able (e.g. posting routines).
- **Blocking poll up to 120 s.** Prefer the async `SendMessage` + `Poll` pattern for foreground UI — see [02-RecordInsights](samples/02-RecordInsights/) and [08-SuggestionNotification](samples/08-SuggestionNotification/).
- **Object IDs of the upstream Smart Agents app are hard-coded** in [QUASmartAgentSDK.Codeunit.al](sdk/src/Codeunits/QUASmartAgentSDK.Codeunit.al) `Init()`. If a Smart Agents major release ever changes those IDs, a new SDK major version will ship.

---

## Who is this for?

- **Business Central partners and ISVs** building AppSource apps with AI features
- **Microsoft Dynamics 365 Business Central consultants** delivering AI-powered customizations to clients
- **AL developers** learning agentic AI patterns: PromptDialog, async background jobs, multi-turn conversations, tool-call confirmation
- **BC customers** evaluating Smart Agents and looking for working examples before committing

---

## Common search terms this repository covers

If you searched for any of these, you're in the right place:

- *Business Central AI* · *D365 BC AI* · *Microsoft Dynamics 365 AI*
- *Business Central Copilot* · *D365 Copilot alternative* · *Copilot for ERP*
- *AI for ERP* · *AI for business* · *ERP automation with LLM*
- *BC AL AI sample* · *AL SDK for AI* · *Business Central AI tutorial*
- *Smart Agents Business Central* · *BC agentic AI* · *AI agents in ERP*
- *PromptDialog example AL* · *Job Queue AI BC* · *BC Copilot Capability alternative*
- *AppSource AI app sample* · *Business Central LLM* · *Business Central GPT*
- *Power Automate Business Central AI* · *BC API for AI agent*

---

## License

[MIT](LICENSE) — copy, modify, redistribute, ship in your own AppSource app. No attribution required (but appreciated).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

Found a security issue? See [SECURITY.md](SECURITY.md).

---

## GitHub topics

To maximize discoverability, set these topics on the repo (UI → About → ⚙️, or run the one-liner in [.github/repo-config.md](.github/repo-config.md)):

```
business-central  d365-business-central  microsoft-dynamics-365  dynamics-365
al-language  al-extension  appsource  bc-extension
ai  artificial-intelligence  llm  generative-ai  agentic-ai  ai-agents
smart-agents  copilot  business-ai  erp-ai  ai-for-business
sdk  sample-code  sample-apps  msdyn365bc
```

## Keywords

Business Central · D365 Business Central · Microsoft Dynamics 365 Business Central · BC · AL · AL Language · AppSource · AI · Artificial Intelligence · Generative AI · Agentic AI · AI Agents · LLM · Large Language Models · GPT · Smart Agents · Copilot · Microsoft Copilot for BC · ERP · ERP automation · AI for business · AI for ERP · Power Automate · Azure OpenAI · SDK · sample apps · partner apps · ISV.
