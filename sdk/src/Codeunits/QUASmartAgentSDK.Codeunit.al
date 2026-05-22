// ============================================================================
// Smart Agents Developer SDK — Zero-Dependency Integration
// ============================================================================
// Either install this app as a dependency, or copy this single file into your
// AL project. There is no compile-time dependency on the Smart Agents app —
// the SDK talks to the installed app at runtime via a message-passing buffer
// table and a facade codeunit, addressed by ID.
//
// Requirements (at runtime):
//   - "Smart Agents for D365 Business Central" is installed in the tenant.
//   - The calling user has the "SA USER QUA" (or "SA ADMIN QUA") permission set.
//
// SETUP when copy-pasting this file (skip if you installed the SDK app):
//   1. Change the codeunit ID `77000` below to a free ID in YOUR object range.
//   2. Optionally rename the AL identifier `"QUA Smart Agent SDK"` to match
//      your own naming convention. Update the examples below if you rename.
//   3. Do NOT change the IDs initialized in `Init()` — they point at objects
//      published by the Smart Agents app and must stay in sync with it.
//
// Usage (one-liner to get an answer):
//
//   var
//       SA: Codeunit "QUA Smart Agent SDK";
//       Result: JsonObject;
//       Err: Text;
//   begin
//       Result := SA.SendMessageAndPoll(1, 'List my top 5 customers', Err);
//       if Err = '' then
//           Message(SA.GetResponse(Result));
//   end;
//
// Multi-turn conversation:
//
//   var
//       SA: Codeunit "QUA Smart Agent SDK";
//       R1, R2: JsonObject;
//       SessionId: Guid;
//       Err: Text;
//   begin
//       R1 := SA.SendMessageAndPoll(1, 'Show open invoices', Err);
//       SessionId := SA.GetSessionId(R1);
//       R2 := SA.SendMessageAndPollInSession(1, SessionId,
//                 'Now filter by amount > 1000', Err);
//   end;
//
// Open full chat UI (agent picker, sessions, multi-turn):
//
//   SA.OpenChat();
//
// Open record-specific chat popup (fixed agent, record context):
//
//   SA.OpenChatForRecord(1, Rec.RecordId);
//
// Create and configure an agent programmatically:
//
//   AgentNo := SA.CreateAgent('My Agent', 'Handles invoices', 'Fast',
//                  'You are a helpful BC assistant.', Err);
//   if AgentNo <> 0 then begin
//       SA.SetAgentCapabilities(AgentNo, true, false, false, false, Err);
//       SA.AddDataSource(AgentNo, 'Sales data', 'Default', '', Err);
//       SA.ActivateAgent(AgentNo, Err);
//   end;
//
// Side effects:
//   Every facade call ends with an implicit Commit() inside the SDK. Do not
//   invoke these methods from inside a transaction whose changes must remain
//   rollback-able (posting routines, batch jobs that must be atomic, etc.).
// ============================================================================
codeunit 77000 "QUA Smart Agent SDK"
{
    Access = Public;

    var
        FacadeTableId: Integer;
        FacadeCodeunitId: Integer;
        FullChatPageId: Integer;
        ChatPopupPageId: Integer;

    // Buffer table field numbers — owned by the Smart Agents app.
    // Kept as constants so future fixes have one place to update.
    procedure BufferField_Method(): Integer
    begin
        exit(2);
    end;

    procedure BufferField_Parameters(): Integer
    begin
        exit(3);
    end;

    procedure BufferField_Response(): Integer
    begin
        exit(4);
    end;

    procedure BufferField_ErrorText(): Integer
    begin
        exit(5);
    end;

    procedure BufferField_IsProcessed(): Integer
    begin
        exit(6);
    end;

    procedure BufferField_BCSessionId(): Integer
    begin
        exit(7);
    end;

    local procedure Init()
    begin
        // Object IDs published by Smart Agents for D365 Business Central.
        // Do NOT change these — they reference objects in the installed app.
        FacadeTableId := 72778326;     // table    "SA API Buffer QUA"
        FacadeCodeunitId := 72778317;  // codeunit "SA API Facade QUA"
        FullChatPageId := 72778302;    // page     "Smart Agent Chat QUA"
        ChatPopupPageId := 72778339;   // page     "SA Chat Popup QUA"
    end;

    // ── Chat UI (popup / full experience) ─────────────────────────────────

    /// <summary>
    /// Open the full Smart Agents Chat experience.
    /// Includes agent picker, session list, multi-turn conversations.
    /// </summary>
    procedure OpenChat()
    begin
        Init();
        Page.Run(FullChatPageId);
    end;

    /// <summary>
    /// Open a chat popup fixed to a specific agent (no record context).
    /// The agent starts in a blank session. Performs an implicit Commit().
    /// </summary>
    /// <param name="AgentNo">Smart Agent No. (must exist and be Active).</param>
    procedure OpenChatForAgent(AgentNo: Integer)
    var
        DummyRecId: RecordId;
    begin
        OpenChatForRecord(AgentNo, DummyRecId);
    end;

    /// <summary>
    /// Open a chat popup fixed to a specific agent with record context.
    /// The agent sees the record and can answer questions about it.
    /// Pass an empty RecordId to open without record context.
    /// Performs an implicit Commit() to publish the buffer row to the popup.
    /// </summary>
    /// <param name="AgentNo">Smart Agent No.</param>
    /// <param name="SourceRecordId">RecordId of the source record (or empty).</param>
    procedure OpenChatForRecord(AgentNo: Integer; SourceRecordId: RecordId)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        Params: JsonObject;
        ParamsText: Text;
    begin
        Init();

        Params.Add('agentNo', AgentNo);
        if Format(SourceRecordId) <> '' then begin
            Params.Add('tableNo', SourceRecordId.TableNo);
            RecRef.Open(SourceRecordId.TableNo);
            if RecRef.Get(SourceRecordId) then
                Params.Add('systemId', Format(RecRef.Field(2000000000).Value));
            RecRef.Close();
        end;

        RecRef.Open(FacadeTableId);
        RecRef.Init();

        FldRef := RecRef.Field(BufferField_Method());
        FldRef.Value := 'OpenChat';

        FldRef := RecRef.Field(BufferField_BCSessionId());
        FldRef.Value := Database.SessionId();

        FldRef := RecRef.Field(BufferField_IsProcessed());
        FldRef.Value := false;

        RecRef.Insert(true);

        Params.WriteTo(ParamsText);
        WriteBlobViaRecRef(RecRef, BufferField_Parameters(), ParamsText);

        Commit();
        RecRef.Close();

        Page.Run(ChatPopupPageId);
    end;

    // ── One-liner convenience ────────────────────────────────────────────

    /// <summary>
    /// Send a message in a new session and block until the agent finishes
    /// (or the default 120 s timeout elapses). Returns the full poll result;
    /// use GetResponse() to read the answer and GetSessionId() to continue
    /// the conversation.
    /// On failure, ErrorText is set and the returned JsonObject is empty.
    /// </summary>
    [NonDebuggable]
    procedure SendMessageAndPoll(AgentNo: Integer; UserMessage: Text; var ErrorText: Text): JsonObject
    begin
        exit(SendMessageAndPoll(AgentNo, UserMessage, 0, ErrorText));
    end;

    /// <summary>
    /// Send a message and wait with explicit timeout in milliseconds.
    /// Pass 0 to use the server default (120 000 ms).
    /// </summary>
    [NonDebuggable]
    procedure SendMessageAndPoll(AgentNo: Integer; UserMessage: Text; MaxWaitMs: Integer; var ErrorText: Text): JsonObject
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('message', UserMessage);
        if MaxWaitMs > 0 then
            Params.Add('maxWaitMs', MaxWaitMs);
        exit(CallFacade('SendMessageAndPoll', Params, ErrorText));
    end;

    /// <summary>
    /// Continue a conversation in an existing session and wait for result.
    /// </summary>
    [NonDebuggable]
    procedure SendMessageAndPollInSession(AgentNo: Integer; SessionId: Guid; UserMessage: Text; var ErrorText: Text): JsonObject
    begin
        exit(SendMessageAndPollInSession(AgentNo, SessionId, UserMessage, 0, ErrorText));
    end;

    /// <summary>
    /// Continue a conversation with explicit timeout.
    /// </summary>
    [NonDebuggable]
    procedure SendMessageAndPollInSession(AgentNo: Integer; SessionId: Guid; UserMessage: Text; MaxWaitMs: Integer; var ErrorText: Text): JsonObject
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('sessionId', Format(SessionId));
        Params.Add('message', UserMessage);
        if MaxWaitMs > 0 then
            Params.Add('maxWaitMs', MaxWaitMs);
        exit(CallFacade('SendMessageAndPollInSession', Params, ErrorText));
    end;

    // ── Async send + manual poll ─────────────────────────────────────────

    /// <summary>
    /// Send a message (creates a new session). Returns a RequestId for polling.
    /// </summary>
    [NonDebuggable]
    procedure SendMessage(AgentNo: Integer; UserMessage: Text; var ErrorText: Text): Text
    var
        Params: JsonObject;
        Result: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('message', UserMessage);
        Result := CallFacade('SendMessage', Params, ErrorText);
        exit(GetJsonText(Result, 'requestId'));
    end;

    /// <summary>
    /// Send a message in an existing session (multi-turn). Returns a RequestId.
    /// </summary>
    [NonDebuggable]
    procedure SendMessageInSession(AgentNo: Integer; SessionId: Guid; UserMessage: Text; var ErrorText: Text): Text
    var
        Params: JsonObject;
        Result: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('sessionId', Format(SessionId));
        Params.Add('message', UserMessage);
        Result := CallFacade('SendMessageInSession', Params, ErrorText);
        exit(GetJsonText(Result, 'requestId'));
    end;

    /// <summary>
    /// Poll for the current state of a request. Returns a JsonObject with
    /// status, response, toolCalls, creditsUsed, tokensUsed, etc.
    /// </summary>
    procedure Poll(AgentNo: Integer; RequestId: Text; var ErrorText: Text): JsonObject
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('requestId', RequestId);
        exit(CallFacade('Poll', Params, ErrorText));
    end;

    // ── Tool call confirmation ───────────────────────────────────────────

    /// <summary>
    /// Auto-approve all pending tool call confirmations for a request.
    /// Use Poll() afterwards to confirm the request has moved past
    /// 'awaiting_confirmation'.
    /// </summary>
    procedure ApproveAllToolCalls(RequestId: Text; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('requestId', RequestId);
        CallFacade('ApproveAllToolCalls', Params, ErrorText);
    end;

    /// <summary>
    /// Reject all pending tool call confirmations for a request.
    /// Use Poll() afterwards to confirm the request has moved past
    /// 'awaiting_confirmation'.
    /// </summary>
    procedure RejectAllToolCalls(RequestId: Text; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('requestId', RequestId);
        CallFacade('RejectAllToolCalls', Params, ErrorText);
    end;

    // ── Agent Management (Create, Configure, Activate, Delete) ───────────

    /// <summary>
    /// Create a new agent in Draft status. Returns the auto-assigned Agent No.,
    /// or 0 if creation failed (in which case ErrorText is populated).
    /// Call ActivateAgent after configuring to provision on the backend.
    /// </summary>
    /// <param name="AIModel">Backend model identifier (e.g. 'Fast'). Pass empty to use the tenant default.</param>
    procedure CreateAgent(AgentName: Text; Description: Text; AIModel: Text; Instructions: Text; var ErrorText: Text): Integer
    var
        Params: JsonObject;
        Result: JsonObject;
    begin
        Params.Add('name', AgentName);
        Params.Add('description', Description);
        Params.Add('aiModel', AIModel);
        Params.Add('instructions', Instructions);
        Result := CallFacade('CreateAgent', Params, ErrorText);
        exit(GetJsonInt(Result, 'agentNo'));
    end;

    /// <summary>
    /// Update agent properties. Pass empty text to leave a field unchanged.
    /// </summary>
    procedure UpdateAgent(AgentNo: Integer; AgentName: Text; Description: Text; AIModel: Text; Instructions: Text; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('name', AgentName);
        Params.Add('description', Description);
        Params.Add('aiModel', AIModel);
        Params.Add('instructions', Instructions);
        CallFacade('UpdateAgent', Params, ErrorText);
    end;

    /// <summary>
    /// Set agent capabilities (which tools the agent can use).
    /// </summary>
    procedure SetAgentCapabilities(AgentNo: Integer; BCDataAccess: Boolean; KnowledgeBase: Boolean; WebSearch: Boolean; ImageAnalysis: Boolean; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('bcDataAccess', BCDataAccess);
        Params.Add('knowledgeBase', KnowledgeBase);
        Params.Add('webSearch', WebSearch);
        Params.Add('imageAnalysis', ImageAnalysis);
        CallFacade('SetAgentCapabilities', Params, ErrorText);
    end;

    /// <summary>
    /// Set the agent autonomy level only (limits unchanged).
    /// AutonomyLevel: 0=Extreme, 1=High, 2=Medium, 3=Low.
    /// </summary>
    procedure SetAgentAutonomy(AgentNo: Integer; AutonomyLevel: Integer; var ErrorText: Text)
    begin
        SetAgentAutonomyAndLimits(AgentNo, AutonomyLevel, 0, 0, 0, ErrorText);
    end;

    /// <summary>
    /// Set agent autonomy level and result/export limits in one call.
    /// AutonomyLevel: 0=Extreme, 1=High, 2=Medium, 3=Low.
    /// Pass 0 for any limit to keep its current value.
    /// </summary>
    procedure SetAgentAutonomyAndLimits(AgentNo: Integer; AutonomyLevel: Integer; MaxSearchResults: Integer; MaxExportRows: Integer; MaxPreviewRows: Integer; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('autonomyLevel', AutonomyLevel);
        Params.Add('maxSearchResults', MaxSearchResults);
        Params.Add('maxExportRows', MaxExportRows);
        Params.Add('maxPreviewRows', MaxPreviewRows);
        CallFacade('SetAgentAutonomy', Params, ErrorText);
    end;

    /// <summary>
    /// Add a data source using the current company context.
    /// Returns the inserted Line No., or 0 on failure.
    /// </summary>
    /// <param name="Description">Human-readable name shown in the UI (e.g. 'Sales data').</param>
    /// <param name="ToolConfigName">Tool configuration to use (e.g. 'Default').</param>
    /// <param name="Usage">Optional instruction telling the agent WHEN to use this source. Auto-injected into the system prompt.</param>
    procedure AddDataSource(AgentNo: Integer; Description: Text; ToolConfigName: Text; Usage: Text; var ErrorText: Text): Integer
    var
        Params: JsonObject;
        Result: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('sourceType', 0);
        Params.Add('description', Description);
        Params.Add('companyName', '');
        Params.Add('environmentName', '');
        Params.Add('toolConfigName', ToolConfigName);
        Params.Add('usage', Usage);
        Result := CallFacade('AddDataSource', Params, ErrorText);
        exit(GetJsonInt(Result, 'lineNo'));
    end;

    /// <summary>
    /// Add a tool link (web resource) to an agent. Returns the Line No.
    /// </summary>
    procedure AddToolLink(AgentNo: Integer; LinkName: Text; URL: Text; Usage: Text; var ErrorText: Text): Integer
    var
        Params: JsonObject;
        Result: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('name', LinkName);
        Params.Add('url', URL);
        Params.Add('usage', Usage);
        Result := CallFacade('AddToolLink', Params, ErrorText);
        exit(GetJsonInt(Result, 'lineNo'));
    end;

    /// <summary>
    /// Add an authorized user to an agent. When no users are configured, agent is open to all.
    /// </summary>
    procedure AddAuthorizedUser(AgentNo: Integer; UserName: Text; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        Params.Add('userName', UserName);
        CallFacade('AddAuthorizedUser', Params, ErrorText);
    end;

    /// <summary>
    /// Activate an agent (provision on backend). The agent must be in Draft
    /// status. Call after CreateAgent + capability/data-source setup.
    /// </summary>
    procedure ActivateAgent(AgentNo: Integer; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        CallFacade('ActivateAgent', Params, ErrorText);
    end;

    /// <summary>
    /// Deactivate an agent (remove from backend, keep local data).
    /// </summary>
    procedure DeactivateAgent(AgentNo: Integer; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        CallFacade('DeactivateAgent', Params, ErrorText);
    end;

    /// <summary>
    /// Push pending local changes for an agent (instructions, capabilities,
    /// data sources, tool links) to the backend. Required after edits to an
    /// already-Active agent; not needed for newly created agents that are
    /// then activated via ActivateAgent.
    /// </summary>
    procedure SyncAgentToBackend(AgentNo: Integer; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        CallFacade('UpdateBackend', Params, ErrorText);
    end;

    /// <summary>
    /// Delete an agent and ALL related data. Irreversible.
    /// </summary>
    procedure DeleteAgent(AgentNo: Integer; var ErrorText: Text)
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        CallFacade('DeleteAgent', Params, ErrorText);
    end;

    /// <summary>
    /// Get agent details as a JsonObject. Keys returned:
    ///   no (Integer), name (Text), description (Text), aiModel (Text),
    ///   status (Text), bcDataAccess (Boolean), knowledgeBase (Boolean),
    ///   webSearch (Boolean), imageAnalysis (Boolean),
    ///   autonomyLevel (Integer 0..3), maxSearchResults (Integer),
    ///   maxExportRows (Integer), maxPreviewRows (Integer).
    /// On failure ErrorText is set and the returned object is empty.
    /// </summary>
    procedure GetAgent(AgentNo: Integer; var ErrorText: Text): JsonObject
    var
        Params: JsonObject;
    begin
        Params.Add('agentNo', AgentNo);
        exit(CallFacade('GetAgent', Params, ErrorText));
    end;

    /// <summary>
    /// List all agents. Returns a JsonObject with an 'agents' JsonArray.
    /// Each entry has: no, name, status, aiModel.
    /// </summary>
    procedure ListAgents(var ErrorText: Text): JsonObject
    var
        Params: JsonObject;
    begin
        exit(CallFacade('ListAgents', Params, ErrorText));
    end;

    // ── Lookup & validation (client-side, no facade needed) ──────────────

    /// <summary>
    /// Opens an agent picker. Returns true if the user selected one and
    /// fills AgentNo + AgentName.
    /// Use this in OnLookup triggers on your setup table fields.
    /// </summary>
    procedure LookupAgent(var AgentNo: Integer; var AgentName: Text[100]): Boolean
    var
        AgentsResult: JsonObject;
        AgentsToken: JsonToken;
        AgentArr: JsonArray;
        AgentToken: JsonToken;
        AgentObj: JsonObject;
        ErrorText: Text;
        MenuOptions: Text;
        AgentNos: List of [Integer];
        AgentNames: List of [Text];
        Selected: Integer;
        i: Integer;
    begin
        AgentsResult := ListAgents(ErrorText);
        if ErrorText <> '' then
            exit(false);

        if not AgentsResult.Get('agents', AgentsToken) then
            exit(false);

        AgentArr := AgentsToken.AsArray();
        if AgentArr.Count = 0 then
            exit(false);

        for i := 0 to AgentArr.Count - 1 do begin
            AgentArr.Get(i, AgentToken);
            AgentObj := AgentToken.AsObject();
            AgentNos.Add(GetJsonInt(AgentObj, 'no'));
            AgentNames.Add(GetJsonText(AgentObj, 'name'));
            if MenuOptions <> '' then
                MenuOptions += ',';
            // StrMenu options are comma-separated; escape commas in agent names.
            MenuOptions +=
                Format(GetJsonInt(AgentObj, 'no')) + ' - ' +
                MaskComma(GetJsonText(AgentObj, 'name'));
        end;

        Selected := StrMenu(MenuOptions, 0, 'Select Agent');
        if Selected = 0 then
            exit(false);

        AgentNo := AgentNos.Get(Selected);
        AgentName := CopyStr(AgentNames.Get(Selected), 1, 100);
        exit(true);
    end;

    local procedure MaskComma(Value: Text): Text
    begin
        // StrMenu separates by literal comma. Replace with the visually similar U+201A.
        exit(Value.Replace(',', '‚'));
    end;

    /// <summary>
    /// Validates that an agent with the given No. exists.
    /// Returns true and fills AgentName if found; false with blank name if not.
    /// Special case: AgentNo = 0 returns true with blank AgentName so users can
    /// clear the field on a setup record.
    /// Use in OnValidate triggers on your setup table fields.
    /// </summary>
    procedure ValidateAgentNo(AgentNo: Integer; var AgentName: Text[100]): Boolean
    var
        AgentResult: JsonObject;
        ErrorText: Text;
    begin
        if AgentNo = 0 then begin
            AgentName := '';
            exit(true);
        end;

        AgentResult := GetAgent(AgentNo, ErrorText);
        if ErrorText <> '' then begin
            AgentName := '';
            exit(false);
        end;

        AgentName := CopyStr(GetJsonText(AgentResult, 'name'), 1, 100);
        exit(AgentName <> '');
    end;

    /// <summary>
    /// Gets the display name for an agent by No. Returns blank if not found.
    /// </summary>
    procedure GetAgentName(AgentNo: Integer): Text[100]
    var
        AgentName: Text[100];
    begin
        ValidateAgentNo(AgentNo, AgentName);
        exit(AgentName);
    end;

    /// <summary>
    /// Opens the Smart Agent chat popup for the given agent No. Intended for
    /// use in OnDrillDown triggers on your setup table fields — the agent's
    /// card page is internal to the Smart Agents app, so drill-down navigates
    /// to chat instead.
    /// No-op if the agent does not exist.
    /// </summary>
    procedure DrillDownAgent(AgentNo: Integer)
    var
        ErrorText: Text;
        AgentResult: JsonObject;
    begin
        AgentResult := GetAgent(AgentNo, ErrorText);
        Clear(AgentResult);
        if ErrorText = '' then
            OpenChatForAgent(AgentNo);
    end;

    // ── Result helpers (local, no facade call) ───────────────────────────

    /// <summary>Status from a poll result: 'pending', 'completed', 'tool_calls_pending', 'awaiting_confirmation'.</summary>
    procedure GetStatus(PollResult: JsonObject): Text
    begin
        exit(GetJsonText(PollResult, 'status'));
    end;

    /// <summary>Agent's text response from a completed poll result.</summary>
    procedure GetResponse(PollResult: JsonObject): Text
    begin
        exit(GetJsonText(PollResult, 'response'));
    end;

    /// <summary>Tool calls array from a poll result; empty if none present.</summary>
    procedure GetToolCalls(PollResult: JsonObject): JsonArray
    var
        Token: JsonToken;
        EmptyArr: JsonArray;
    begin
        if PollResult.Get('toolCalls', Token) then
            exit(Token.AsArray());
        exit(EmptyArr);
    end;

    /// <summary>Credits used from a completed poll result.</summary>
    procedure GetCreditsUsed(PollResult: JsonObject): Decimal
    var
        Token: JsonToken;
    begin
        if PollResult.Get('creditsUsed', Token) then
            exit(Token.AsValue().AsDecimal());
        exit(0);
    end;

    /// <summary>Total tokens used from a completed poll result.</summary>
    procedure GetTokensUsed(PollResult: JsonObject): Integer
    begin
        exit(GetJsonInt(PollResult, 'tokensUsed'));
    end;

    /// <summary>Prompt (input) tokens from a completed poll result.</summary>
    procedure GetPromptTokens(PollResult: JsonObject): Integer
    begin
        exit(GetJsonInt(PollResult, 'promptTokens'));
    end;

    /// <summary>Completion (output) tokens from a completed poll result.</summary>
    procedure GetCompletionTokens(PollResult: JsonObject): Integer
    begin
        exit(GetJsonInt(PollResult, 'completionTokens'));
    end;

    /// <summary>
    /// Session GUID from a poll/send result. Returns an empty GUID if no
    /// 'sessionId' key is present or the value is unparseable. Use to
    /// continue the conversation with SendMessageAndPollInSession.
    /// </summary>
    procedure GetSessionId(Result: JsonObject): Guid
    var
        Id: Guid;
        IdText: Text;
    begin
        IdText := GetJsonText(Result, 'sessionId');
        if IdText = '' then
            exit(Id);
        if not Evaluate(Id, IdText) then
            Clear(Id);
        exit(Id);
    end;

    /// <summary>
    /// Returns true if the Smart Agents extension is installed and the
    /// buffer table is reachable in the current session. Call once at
    /// startup to fail fast before exposing SDK-backed UI to the user.
    /// Does NOT verify the user has the SA USER permission set.
    /// </summary>
    procedure IsSmartAgentsInstalled(): Boolean
    begin
        exit(TryOpenFacadeTable());
    end;

    // ── Internal facade bridge ───────────────────────────────────────────

    [NonDebuggable]
    local procedure CallFacade(Method: Text; Params: JsonObject; var ErrorText: Text): JsonObject
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        ParamsText: Text;
        ResponseText: Text;
        Result: JsonObject;
        StartedAt: DateTime;
    begin
        Init();
        StartedAt := CurrentDateTime();

        LogStart(Method);

        RecRef.Open(FacadeTableId);
        RecRef.Init();

        FldRef := RecRef.Field(BufferField_Method());
        FldRef.Value := Method;

        FldRef := RecRef.Field(BufferField_BCSessionId());
        FldRef.Value := Database.SessionId();

        FldRef := RecRef.Field(BufferField_IsProcessed());
        FldRef.Value := false;

        RecRef.Insert(true);

        Params.WriteTo(ParamsText);
        WriteBlobViaRecRef(RecRef, BufferField_Parameters(), ParamsText);

        Commit();

        Codeunit.Run(FacadeCodeunitId);

        RecRef.SetRecFilter();
        RecRef.FindFirst();

        FldRef := RecRef.Field(BufferField_ErrorText());
        ErrorText := Format(FldRef.Value);

        ResponseText := ReadBlobViaRecRef(RecRef, BufferField_Response());

        if ResponseText <> '' then
            if not Result.ReadFrom(ResponseText) then
                ErrorText := 'Failed to parse response JSON.';

        RecRef.Delete();
        RecRef.Close();

        if ErrorText = '' then
            LogSuccess(Method, StartedAt, Result)
        else
            LogError(Method, ErrorText);

        exit(Result);
    end;

    local procedure WriteBlobViaRecRef(var RecRef: RecordRef; FieldNo: Integer; Content: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        FldRef: FieldRef;
    begin
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Content);
        FldRef := RecRef.Field(FieldNo);
        TempBlob.ToFieldRef(FldRef);
        RecRef.Modify();
    end;

    local procedure ReadBlobViaRecRef(var RecRef: RecordRef; FieldNo: Integer): Text
    var
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        FldRef: FieldRef;
        Result: Text;
        Line: Text;
    begin
        FldRef := RecRef.Field(FieldNo);
        TempBlob.FromFieldRef(FldRef);
        if not TempBlob.HasValue() then
            exit('');
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        while not InStr.EOS() do begin
            InStr.ReadText(Line);
            Result += Line;
        end;
        exit(Result);
    end;

    [TryFunction]
    local procedure TryOpenFacadeTable()
    var
        RecRef: RecordRef;
    begin
        Init();
        RecRef.Open(FacadeTableId);
        RecRef.Close();
    end;

    local procedure GetJsonText(JObj: JsonObject; PropName: Text): Text
    var
        Token: JsonToken;
    begin
        if JObj.Get(PropName, Token) then
            exit(Token.AsValue().AsText());
        exit('');
    end;

    local procedure GetJsonInt(JObj: JsonObject; PropName: Text): Integer
    var
        Token: JsonToken;
    begin
        if JObj.Get(PropName, Token) then
            exit(Token.AsValue().AsInteger());
        exit(0);
    end;

    // ── Telemetry ────────────────────────────────────────────────────────

    local procedure LogStart(Method: Text)
    var
        Dims: Dictionary of [Text, Text];
    begin
        Dims.Add('method', Method);
        Session.LogMessage(
            'QUA-SA-0001', 'Smart Agent facade call started',
            Verbosity::Normal, DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher, Dims);
    end;

    local procedure LogSuccess(Method: Text; StartedAt: DateTime; Result: JsonObject)
    var
        Dims: Dictionary of [Text, Text];
    begin
        Dims.Add('method', Method);
        Dims.Add('durationMs', Format(CurrentDateTime() - StartedAt));
        Dims.Add('tokensUsed', Format(GetTokensUsed(Result)));
        Dims.Add('creditsUsed', Format(GetCreditsUsed(Result)));
        Session.LogMessage(
            'QUA-SA-0002', 'Smart Agent facade call completed',
            Verbosity::Normal, DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher, Dims);
    end;

    local procedure LogError(Method: Text; ErrorText: Text)
    var
        Dims: Dictionary of [Text, Text];
    begin
        Dims.Add('method', Method);
        Dims.Add('errorText', ErrorText);
        Session.LogMessage(
            'QUA-SA-0003', 'Smart Agent facade call failed',
            Verbosity::Error, DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher, Dims);
    end;
}
