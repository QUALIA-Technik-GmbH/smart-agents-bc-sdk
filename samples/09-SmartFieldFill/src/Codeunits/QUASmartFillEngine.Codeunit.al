/// <summary>
/// Asks the configured agent to translate a free-text description into a
/// JSON object with itemNo + quantity, then writes those onto the Sales Line.
/// </summary>
codeunit 77171 "QUA Smart Fill Engine"
{
    Access = Public;

    var
        PromptTemplateLbl: Label 'Parse the following sales line description into an Item No. and Quantity. Reply with ONLY a JSON object on a single line, no prose: {"itemNo":"<existing Item No.>","quantity":<integer>}. If you cannot identify an item, reply with {"itemNo":"","quantity":0}. Description: %1', Locked = true;
        NoAgentErr: Label 'Set the Smart Fill Agent No. on Sales & Receivables Setup to use Auto-Fill.';
        ParseErr: Label 'The agent reply was not valid JSON: %1', Comment = '%1 = the raw reply';
        AgentFailedErr: Label 'The Smart Agent failed: %1', Comment = '%1 = error text';
        NoMatchMsg: Label 'The agent could not identify an item in the description.';

    procedure AutoFill(var SalesLine: Record "Sales Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Reply: JsonObject;
        Token: JsonToken;
        ErrorText: Text;
        Response: Text;
        Prompt: Text;
        ItemNo: Code[20];
        Quantity: Decimal;
    begin
        SalesSetup.Get();
        if SalesSetup."QUA Smart Fill Agent No." = 0 then
            Error(NoAgentErr);

        if SalesLine.Description = '' then
            exit;

        Prompt := StrSubstNo(PromptTemplateLbl, SalesLine.Description);

        Result := SA.SendMessageAndPoll(SalesSetup."QUA Smart Fill Agent No.", Prompt, 60000, ErrorText);
        if ErrorText <> '' then
            Error(AgentFailedErr, ErrorText);

        Response := SA.GetResponse(Result);
        if not Reply.ReadFrom(Response) then
            Error(ParseErr, Response);

        if Reply.Get('itemNo', Token) then
            ItemNo := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(ItemNo));
        if Reply.Get('quantity', Token) then
            Quantity := Token.AsValue().AsDecimal();

        if (ItemNo = '') or (Quantity <= 0) then begin
            Message(NoMatchMsg);
            exit;
        end;

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate(Quantity, Quantity);
        SalesLine.Modify(true);
    end;
}
