/// <summary>
/// Event subscriber on "Approval Entry" that asks the agent for a
/// recommendation and persists it. Errors are swallowed — the approval
/// workflow must keep working even if the agent is down.
/// </summary>
codeunit 77232 "QUA Approval Recommender"
{
    Access = Internal;

    var
        PromptTemplateLbl: Label 'You are advising the approver of a Business Central approval request. Reply with ONLY a JSON object on a single line, no prose: {"decision":"Approve|Reject|Hold","reason":"<one short paragraph>"}. Approval Entry No.=%1, Table ID=%2, Document No.=%3, Amount=%4, Sender User ID=%5.', Locked = true;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertApprovalEntry(var Rec: Record "Approval Entry"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;
        RecommendFor(Rec);
    end;

    local procedure RecommendFor(ApprovalEntry: Record "Approval Entry")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Recommendation: Record "QUA Approval Recommendation";
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        Reply: JsonObject;
        Token: JsonToken;
        ErrorText: Text;
        Response: Text;
        Prompt: Text;
        DecisionText: Text;
    begin
        if not SalesSetup.Get() then
            exit;
        if SalesSetup."QUA Approval Agent No." = 0 then
            exit;

        Prompt := StrSubstNo(
            PromptTemplateLbl,
            ApprovalEntry."Entry No.",
            ApprovalEntry."Table ID",
            ApprovalEntry."Document No.",
            Format(ApprovalEntry.Amount, 0, 9),
            ApprovalEntry."Sender ID");

        Result := SA.SendMessageAndPoll(SalesSetup."QUA Approval Agent No.", Prompt, 60000, ErrorText);
        if ErrorText <> '' then
            exit;

        Response := SA.GetResponse(Result);
        if not Reply.ReadFrom(Response) then
            exit;

        Recommendation.Init();
        Recommendation."Approval Entry No." := ApprovalEntry."Entry No.";
        Recommendation.Decision := Recommendation.Decision::Hold;

        if Reply.Get('decision', Token) then begin
            DecisionText := UpperCase(Token.AsValue().AsText());
            case DecisionText of
                'APPROVE':
                    Recommendation.Decision := Recommendation.Decision::Approve;
                'REJECT':
                    Recommendation.Decision := Recommendation.Decision::Reject;
            end;
        end;

        if Reply.Get('reason', Token) then
            Recommendation.Reason := CopyStr(Token.AsValue().AsText(), 1, MaxStrLen(Recommendation.Reason));

        Recommendation."Generated At" := CurrentDateTime();
        if Recommendation.Insert(true) then;
    end;
}
