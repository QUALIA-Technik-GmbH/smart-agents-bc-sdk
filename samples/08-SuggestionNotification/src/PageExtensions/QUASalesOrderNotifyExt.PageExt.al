/// <summary>
/// Fires a Suggestion Runner on Sales Order open. The runner is best-effort —
/// it silently exits if no agent is configured or the agent returns NONE.
/// </summary>
pageextension 77152 "QUA Sales Order Notify Ext" extends "Sales Order"
{
    trigger OnAfterGetCurrRecord()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Runner: Codeunit "QUA Suggestion Runner";
    begin
        if Rec."No." = '' then
            exit;
        SalesSetup.Get();
        if SalesSetup."QUA Suggestion Agent No." = 0 then
            exit;
        Runner.SuggestForSalesHeader(Rec, SalesSetup."QUA Suggestion Agent No.");
    end;
}
