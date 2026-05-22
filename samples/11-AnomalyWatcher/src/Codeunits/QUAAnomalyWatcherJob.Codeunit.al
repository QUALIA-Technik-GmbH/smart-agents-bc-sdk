/// <summary>
/// Job Queue–runnable anomaly scanner. Asks the agent for findings and
/// persists each as a row on "QUA Anomaly Finding".
/// </summary>
codeunit 77212 "QUA Anomaly Watcher Job"
{
    Access = Public;
    TableNo = "Job Queue Entry";

    var
        PromptLbl: Label 'Scan recent G/L Entries (table 17) for unusual patterns in the last 7 days. Reply with ONLY a JSON array on a single line, no prose. Each item must be {"severity":"Info|Warning|Critical","title":"<short>","details":"<one paragraph>","relatedDocumentNo":"<G/L document no. or empty>"}. Return an empty array if nothing notable was found.', Locked = true;
        NoAgentErr: Label 'Set the Anomaly Agent No. on Sales & Receivables Setup before scheduling this job.';

    trigger OnRun()
    begin
        Scan();
    end;

    procedure Scan()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Findings: JsonArray;
        Token: JsonToken;
        ErrorText: Text;
        Response: Text;
        i: Integer;
        DetectedAt: DateTime;
    begin
        SalesSetup.Get();
        if SalesSetup."QUA Anomaly Agent No." = 0 then
            Error(NoAgentErr);

        Result := SA.SendMessageAndPoll(SalesSetup."QUA Anomaly Agent No.", PromptLbl, 180000, ErrorText);
        if ErrorText <> '' then
            exit;

        Response := SA.GetResponse(Result);
        if not Findings.ReadFrom(Response) then
            exit;

        DetectedAt := CurrentDateTime();
        for i := 0 to Findings.Count - 1 do begin
            Findings.Get(i, Token);
            InsertFinding(Token.AsObject(), DetectedAt);
        end;
    end;

    local procedure InsertFinding(Obj: JsonObject; DetectedAt: DateTime)
    var
        Finding: Record "QUA Anomaly Finding";
        Token: JsonToken;
        SeverityText: Text;
    begin
        Finding.Init();
        Finding."Detected At" := DetectedAt;
        Finding.Severity := Finding.Severity::Info;

        if Obj.Get('severity', Token) then begin
            SeverityText := UpperCase(Token.AsValue().AsText());
            case SeverityText of
                'WARNING':
                    Finding.Severity := Finding.Severity::Warning;
                'CRITICAL':
                    Finding.Severity := Finding.Severity::Critical;
            end;
        end;

        if Obj.Get('title', Token) then
            Finding.Title := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(Finding.Title));
        if Obj.Get('details', Token) then
            Finding.Details := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(Finding.Details));
        if Obj.Get('relatedDocumentNo', Token) then
            Finding."Related Document No." := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(Finding."Related Document No."));

        Finding.Insert(true);
    end;
}
