/// <summary>
/// REST API page that proxies a Smart Agent prompt to external callers.
/// </summary>
page 77273 "QUA Ask Agent API"
{
    PageType = API;
    APIPublisher = 'qualiaTechnik';
    APIGroup = 'agentBridge';
    APIVersion = 'v1.0';
    EntityName = 'askAgent';
    EntitySetName = 'askAgent';
    SourceTable = "QUA Ask Agent Buffer";
    SourceTableTemporary = true;
    DelayedInsert = true;
    ODataKeyFields = "Agent No.";

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(agentNo; Rec."Agent No.") { Caption = 'agentNo'; }
                field(prompt; Rec.Prompt) { Caption = 'prompt'; }
                field(status; Rec.Status) { Caption = 'status'; Editable = false; }
                field(response; Rec.Response) { Caption = 'response'; Editable = false; }
                field(tokensUsed; Rec."Tokens Used") { Caption = 'tokensUsed'; Editable = false; }
                field(errorText; Rec."Error Text") { Caption = 'errorText'; Editable = false; }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Bridge: Codeunit "QUA Flow Agent Bridge";
        Status: Text;
        Response: Text;
        ErrorText: Text;
        TokensUsed: Integer;
    begin
        Bridge.Ask(Rec."Agent No.", Rec.Prompt, Status, Response, TokensUsed, ErrorText);
        Rec.Status := CopyStr(Status, 1, MaxStrLen(Rec.Status));
        Rec.Response := CopyStr(Response, 1, MaxStrLen(Rec.Response));
        Rec."Tokens Used" := TokensUsed;
        Rec."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(Rec."Error Text"));
        exit(true);
    end;
}
