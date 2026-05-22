/// <summary>
/// Shows the AI recommendation on the Approval Entries list page.
/// </summary>
pageextension 77233 "QUA Approval Entries Ext" extends "Approval Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(QUAAIDecision; AIDecision)
            {
                ApplicationArea = All;
                Caption = 'AI Decision';
                ToolTip = 'Specifies the agent''s recommended decision for this approval entry.';
                Editable = false;
            }
            field(QUAAIReason; AIReason)
            {
                ApplicationArea = All;
                Caption = 'AI Reason';
                ToolTip = 'Specifies the agent''s reasoning behind the recommendation.';
                Editable = false;
            }
        }
    }

    var
        AIDecision: Text[20];
        AIReason: Text[2048];

    trigger OnAfterGetRecord()
    var
        Recommendation: Record "QUA Approval Recommendation";
    begin
        AIDecision := '';
        AIReason := '';
        if Recommendation.Get(Rec."Entry No.") then begin
            AIDecision := Format(Recommendation.Decision);
            AIReason := Recommendation.Reason;
        end;
    end;
}
