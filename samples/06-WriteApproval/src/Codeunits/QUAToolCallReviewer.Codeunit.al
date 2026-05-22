/// <summary>
/// Wraps the async send + poll-until-confirmation loop and the post-approval
/// poll-until-completed loop. Keeps the page free of polling logic.
/// </summary>
codeunit 77111 "QUA Tool Call Reviewer"
{
    Access = Public;

    var
        PollIntervalMs: Integer;
        MaxPollAttempts: Integer;

    procedure SendUntilConfirmation(AgentNo: Integer; UserMessage: Text; var RequestId: Text; var ToolCalls: JsonArray; var ErrorText: Text): Boolean
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Status: Text;
        Attempts: Integer;
    begin
        InitDefaults();

        RequestId := SA.SendMessage(AgentNo, UserMessage, ErrorText);
        if (ErrorText <> '') or (RequestId = '') then
            exit(false);

        repeat
            Sleep(PollIntervalMs);
            Result := SA.Poll(AgentNo, RequestId, ErrorText);
            if ErrorText <> '' then
                exit(false);
            Status := SA.GetStatus(Result);
            Attempts += 1;
        until (Status = 'awaiting_confirmation') or (Status = 'completed') or (Attempts >= MaxPollAttempts);

        if Status = 'awaiting_confirmation' then begin
            ToolCalls := SA.GetToolCalls(Result);
            exit(true);
        end;

        // Completed without needing a confirmation — return the empty array.
        Clear(ToolCalls);
        exit(Status = 'completed');
    end;

    procedure ApproveAndWait(AgentNo: Integer; RequestId: Text; var FinalResult: JsonObject; var ErrorText: Text): Boolean
    var
        SA: Codeunit "QUA Smart Agent SDK";
    begin
        InitDefaults();

        SA.ApproveAllToolCalls(RequestId, ErrorText);
        if ErrorText <> '' then
            exit(false);

        exit(WaitForCompletion(AgentNo, RequestId, FinalResult, ErrorText));
    end;

    procedure RejectAndWait(AgentNo: Integer; RequestId: Text; var FinalResult: JsonObject; var ErrorText: Text): Boolean
    var
        SA: Codeunit "QUA Smart Agent SDK";
    begin
        InitDefaults();

        SA.RejectAllToolCalls(RequestId, ErrorText);
        if ErrorText <> '' then
            exit(false);

        exit(WaitForCompletion(AgentNo, RequestId, FinalResult, ErrorText));
    end;

    local procedure WaitForCompletion(AgentNo: Integer; RequestId: Text; var FinalResult: JsonObject; var ErrorText: Text): Boolean
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Status: Text;
        Attempts: Integer;
    begin
        repeat
            Sleep(PollIntervalMs);
            FinalResult := SA.Poll(AgentNo, RequestId, ErrorText);
            if ErrorText <> '' then
                exit(false);
            Status := SA.GetStatus(FinalResult);
            Attempts += 1;
        until (Status = 'completed') or (Attempts >= MaxPollAttempts);

        exit(Status = 'completed');
    end;

    local procedure InitDefaults()
    begin
        if PollIntervalMs = 0 then
            PollIntervalMs := 1500;
        if MaxPollAttempts = 0 then
            MaxPollAttempts := 30;
    end;
}
