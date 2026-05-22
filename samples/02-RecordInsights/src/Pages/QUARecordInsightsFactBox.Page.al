/// <summary>
/// FactBox surface for AI-generated insights on the Customer Card.
/// Shows a placeholder while loading, then the agent's response.
/// </summary>
page 77032 "QUA Record Insights FactBox"
{
    PageType = CardPart;
    Caption = 'AI Insights';
    Editable = false;
    ApplicationArea = All;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            field(InsightText; InsightText)
            {
                ApplicationArea = All;
                MultiLine = true;
                ShowCaption = false;
                ToolTip = 'Specifies AI-generated insights for this customer.';
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Ask the Smart Agent again for fresh insights about this customer.';

                trigger OnAction()
                begin
                    LoadInsight();
                end;
            }
        }
    }

    var
        InsightText: Text;
        LoadingMsg: Label 'Generating insights…';
        NoAgentMsg: Label 'Set the Record Insights Agent No. on Sales & Receivables Setup to enable AI insights.';

    trigger OnAfterGetCurrRecord()
    begin
        LoadInsight();
    end;

    local procedure LoadInsight()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Runner: Codeunit "QUA Record Insights Runner";
        Response: Text;
    begin
        SalesSetup.Get();
        if SalesSetup."QUA Record Insights Agent No." = 0 then begin
            InsightText := NoAgentMsg;
            exit;
        end;

        InsightText := LoadingMsg;
        CurrPage.Update(false);

        Response := Runner.GetInsightFor(Rec, SalesSetup."QUA Record Insights Agent No.");
        if Response = '' then
            InsightText := ''
        else
            InsightText := Response;
    end;
}
