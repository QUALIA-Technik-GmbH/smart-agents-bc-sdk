/// <summary>
/// Calls the configured agent for a JSON array of journal-line specs and
/// inserts them on the configured Template + Batch.
/// </summary>
codeunit 77191 "QUA Journal Line Builder"
{
    Access = Public;

    var
        PromptTemplateLbl: Label 'Convert this free-text description into one or more General Journal lines. Reply with ONLY a JSON array on a single line, no prose. Each item must be {"postingDate":"YYYY-MM-DD","accountNo":"<G/L Account>","description":"<text>","amount":<decimal>}. Use negative amounts for credits. Description: %1', Locked = true;
        NoAgentErr: Label 'Set the Journal Builder Agent No., Template, and Batch on Sales & Receivables Setup.';
        ParseErr: Label 'The agent reply was not a JSON array: %1', Comment = '%1 = raw reply';
        AgentFailedErr: Label 'The Smart Agent failed: %1', Comment = '%1 = error text';
        InsertedMsg: Label '%1 journal line(s) inserted into %2 / %3.', Comment = '%1 = count, %2 = template, %3 = batch';
        NoLinesMsg: Label 'The agent returned an empty list.';

    procedure BuildFromText(FreeText: Text)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Reply: JsonArray;
        Token: JsonToken;
        ErrorText: Text;
        Response: Text;
        Prompt: Text;
        InsertedCount: Integer;
        i: Integer;
    begin
        SalesSetup.Get();
        if (SalesSetup."QUA Journal Agent No." = 0) or
           (SalesSetup."QUA Journal Template Name" = '') or
           (SalesSetup."QUA Journal Batch Name" = '')
        then
            Error(NoAgentErr);

        Prompt := StrSubstNo(PromptTemplateLbl, FreeText);
        Result := SA.SendMessageAndPoll(SalesSetup."QUA Journal Agent No.", Prompt, 90000, ErrorText);
        if ErrorText <> '' then
            Error(AgentFailedErr, ErrorText);

        Response := SA.GetResponse(Result);
        if not Reply.ReadFrom(Response) then
            Error(ParseErr, Response);

        if Reply.Count = 0 then begin
            Message(NoLinesMsg);
            exit;
        end;

        for i := 0 to Reply.Count - 1 do begin
            Reply.Get(i, Token);
            if InsertLine(SalesSetup."QUA Journal Template Name", SalesSetup."QUA Journal Batch Name", Token.AsObject()) then
                InsertedCount += 1;
        end;

        Message(InsertedMsg, InsertedCount, SalesSetup."QUA Journal Template Name", SalesSetup."QUA Journal Batch Name");
    end;

    local procedure InsertLine(TemplateName: Code[10]; BatchName: Code[10]; LineObj: JsonObject): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        Token: JsonToken;
        PostingDateText: Text;
        PostingDate: Date;
        NextLineNo: Integer;
    begin
        GenJnlLine.SetRange("Journal Template Name", TemplateName);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        if GenJnlLine.FindLast() then
            NextLineNo := GenJnlLine."Line No." + 10000
        else
            NextLineNo := 10000;

        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := TemplateName;
        GenJnlLine."Journal Batch Name" := BatchName;
        GenJnlLine."Line No." := NextLineNo;

        if LineObj.Get('postingDate', Token) then begin
            PostingDateText := Token.AsValue().AsText();
            if Evaluate(PostingDate, PostingDateText, 9) then
                GenJnlLine.Validate("Posting Date", PostingDate);
        end;
        if GenJnlLine."Posting Date" = 0D then
            GenJnlLine.Validate("Posting Date", WorkDate());

        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        if LineObj.Get('accountNo', Token) then
            GenJnlLine.Validate("Account No.", CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(GenJnlLine."Account No.")));

        if LineObj.Get('description', Token) then
            GenJnlLine.Validate(Description, CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(GenJnlLine.Description)));

        if LineObj.Get('amount', Token) then
            GenJnlLine.Validate(Amount, Token.AsValue().AsDecimal());

        exit(GenJnlLine.Insert(true));
    end;
}
