/// <summary>
/// Adds an "Ask AI" action to the Sales Quote page that opens the Smart Agent
/// chat scoped to the current quote.
/// </summary>
pageextension 77053 "QUA Sales Quote Chat Ext" extends "Sales Quote"
{
    actions
    {
        addlast(processing)
        {
            action(QUAAskAI)
            {
                ApplicationArea = All;
                Caption = 'Ask AI';
                Image = SparkleFilled;
                ToolTip = 'Open the Smart Agent chat with this sales quote as context.';

                trigger OnAction()
                var
                    SalesSetup: Record "Sales & Receivables Setup";
                    SA: Codeunit "QUA Smart Agent SDK";
                    NoAgentErr: Label 'Set the Card Chat Agent No. on Sales & Receivables Setup to use this action.';
                begin
                    SalesSetup.Get();
                    if SalesSetup."QUA Card Chat Agent No." = 0 then
                        Error(NoAgentErr);
                    SA.OpenChatForRecord(SalesSetup."QUA Card Chat Agent No.", Rec.RecordId);
                end;
            }
        }
    }
}
