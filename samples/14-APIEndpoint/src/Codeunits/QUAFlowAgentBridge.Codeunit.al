/// <summary>
/// Routes an external request to the SDK and records the call in the audit
/// log. Kept separate from the API page so the same bridge can be reused by
/// other facades (e.g. a Webhook endpoint) later.
/// </summary>
codeunit 77272 "QUA Flow Agent Bridge"
{
    Access = Public;

    var
        InvalidRequestErr: Label 'agentNo and prompt are required.';

    procedure Ask(AgentNo: Integer; Prompt: Text; var Status: Text; var Response: Text; var TokensUsed: Integer; var ErrorText: Text)
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Log: Record "QUA Flow Agent Call Log";
    begin
        if (AgentNo = 0) or (Prompt = '') then
            Error(InvalidRequestErr);

        Log.Init();
        Log."Called At" := CurrentDateTime();
        Log."Called By" := CopyStr(UserId(), 1, MaxStrLen(Log."Called By"));
        Log."Agent No." := AgentNo;
        Log."Prompt Excerpt" := CopyStr(Prompt, 1, MaxStrLen(Log."Prompt Excerpt"));
        Log.Insert(true);

        Result := SA.SendMessageAndPoll(AgentNo, Prompt, 120000, ErrorText);

        if ErrorText <> '' then begin
            Status := 'failed';
            Log.Status := CopyStr(Status, 1, MaxStrLen(Log.Status));
            Log."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(Log."Error Text"));
            Log.Modify(true);
            exit;
        end;

        Status := SA.GetStatus(Result);
        Response := SA.GetResponse(Result);
        TokensUsed := SA.GetTokensUsed(Result);

        Log.Status := CopyStr(Status, 1, MaxStrLen(Log.Status));
        Log."Tokens Used" := TokensUsed;
        Log.Modify(true);
    end;
}
