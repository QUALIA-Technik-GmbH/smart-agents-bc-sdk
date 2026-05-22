/// <summary>
/// Wraps the SDK's async SendMessage + Poll loop so a FactBox can fetch
/// insights without blocking the UI. The loop sleeps between polls and gives
/// up after a configurable number of attempts.
/// </summary>
codeunit 77031 "QUA Record Insights Runner"
{
    Access = Public;

    var
        PollIntervalMs: Integer;
        MaxPollAttempts: Integer;
        PromptTemplateLbl: Label 'Summarize this customer in 4-6 sentences. Cover open balance, recent payment behaviour, and any noteworthy ledger entries. Customer No.=%1, Name=%2.', Locked = true;

    /// <summary>
    /// Run a synchronous-looking insight fetch for a Customer. The procedure
    /// returns when the agent finishes, errors, or the poll budget runs out.
    /// </summary>
    procedure GetInsightFor(CustomerRec: Record Customer; AgentNo: Integer): Text
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Prompt: Text;
        RequestId: Text;
        ErrorText: Text;
        Status: Text;
        Attempts: Integer;
    begin
        if AgentNo = 0 then
            exit('');

        if PollIntervalMs = 0 then
            PollIntervalMs := 1500;
        if MaxPollAttempts = 0 then
            MaxPollAttempts := 30;

        Prompt := StrSubstNo(PromptTemplateLbl, CustomerRec."No.", CustomerRec.Name);

        RequestId := SA.SendMessage(AgentNo, Prompt, ErrorText);
        if (ErrorText <> '') or (RequestId = '') then
            exit('');

        repeat
            Sleep(PollIntervalMs);
            Result := SA.Poll(AgentNo, RequestId, ErrorText);
            if ErrorText <> '' then
                exit('');
            Status := SA.GetStatus(Result);
            Attempts += 1;
        until (Status = 'completed') or (Attempts >= MaxPollAttempts);

        if Status <> 'completed' then
            exit('');

        exit(SA.GetResponse(Result));
    end;

    /// <summary>Override the poll cadence (ms between polls).</summary>
    procedure SetPollInterval(IntervalMs: Integer)
    begin
        PollIntervalMs := IntervalMs;
    end;

    /// <summary>Override the maximum number of poll attempts before giving up.</summary>
    procedure SetMaxAttempts(Attempts: Integer)
    begin
        MaxPollAttempts := Attempts;
    end;
}
