/// <summary>
/// Per-customer worker. Sends one prompt to the agent, persists the answer.
/// </summary>
codeunit 77072 "QUA Bulk Processor Runner"
{
    Access = Public;

    procedure ProcessOne(var CustomerRec: Record Customer; var Setup: Record "QUA Bulk Processor Setup"; RunStartedAt: DateTime)
    var
        SA: Codeunit "QUA Smart Agent SDK";
        ResultRec: Record "QUA Bulk Processor Result";
        AgentResult: JsonObject;
        ErrorText: Text;
        Prompt: Text;
        Response: Text;
        OutStr: OutStream;
    begin
        Prompt := StrSubstNo(Setup."Prompt Template", CustomerRec."No.", CustomerRec.Name);

        ResultRec.Init();
        ResultRec."Run Started At" := RunStartedAt;
        ResultRec."Customer No." := CustomerRec."No.";
        ResultRec."Customer Name" := CustomerRec.Name;
        ResultRec.Status := ResultRec.Status::Pending;
        ResultRec.Insert(true);

        AgentResult := SA.SendMessageAndPoll(Setup."Agent No.", Prompt, Setup."Max Wait (ms)", ErrorText);

        if ErrorText <> '' then begin
            ResultRec.Status := ResultRec.Status::Failed;
            ResultRec."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(ResultRec."Error Text"));
            ResultRec.Modify(true);
            exit;
        end;

        Response := SA.GetResponse(AgentResult);
        ResultRec.Status := ResultRec.Status::Completed;
        ResultRec."Response Excerpt" := CopyStr(Response, 1, MaxStrLen(ResultRec."Response Excerpt"));
        ResultRec."Tokens Used" := SA.GetTokensUsed(AgentResult);
        ResultRec."Full Response".CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Response);
        ResultRec.Modify(true);
    end;
}
