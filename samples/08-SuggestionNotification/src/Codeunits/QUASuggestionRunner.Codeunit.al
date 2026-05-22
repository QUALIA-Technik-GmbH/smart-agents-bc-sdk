/// <summary>
/// Asks the agent for a short suggestion about a Sales Order header and, if
/// the response is not 'NONE', dispatches a BC Notification.
/// </summary>
codeunit 77151 "QUA Suggestion Runner"
{
    Access = Public;

    var
        PromptTemplateLbl: Label 'In one short sentence (max 120 characters), suggest whether the user should review this Sales Order before proceeding. Sales Order No.=%1, Sell-to Customer No.=%2. If nothing is worth flagging, reply with the literal word NONE.', Locked = true;
        NoneSentinelLbl: Label 'NONE', Locked = true;

    procedure SuggestForSalesHeader(var SalesHeader: Record "Sales Header"; AgentNo: Integer)
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Notif: Notification;
        Result: JsonObject;
        RequestId: Text;
        ErrorText: Text;
        Response: Text;
        Status: Text;
        Attempts: Integer;
        Prompt: Text;
    begin
        if AgentNo = 0 then
            exit;

        Prompt := StrSubstNo(PromptTemplateLbl, SalesHeader."No.", SalesHeader."Sell-to Customer No.");

        RequestId := SA.SendMessage(AgentNo, Prompt, ErrorText);
        if (ErrorText <> '') or (RequestId = '') then
            exit;

        repeat
            Sleep(1500);
            Result := SA.Poll(AgentNo, RequestId, ErrorText);
            if ErrorText <> '' then
                exit;
            Status := SA.GetStatus(Result);
            Attempts += 1;
        until (Status = 'completed') or (Attempts >= 20);

        if Status <> 'completed' then
            exit;

        Response := SA.GetResponse(Result);
        if (Response = '') or (UpperCase(Response) = NoneSentinelLbl) then
            exit;

        Notif.Message(CopyStr(Response, 1, 250));
        Notif.Scope := NotificationScope::LocalScope;
        Notif.Send();
    end;
}
