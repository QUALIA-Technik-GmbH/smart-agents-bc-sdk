/// <summary>
/// Adds the AI Insights FactBox to the Customer Card.
/// </summary>
pageextension 77033 "QUA Customer Card Insights" extends "Customer Card"
{
    layout
    {
        addlast(factboxes)
        {
            part(QUARecordInsights; "QUA Record Insights FactBox")
            {
                ApplicationArea = All;
                Caption = 'AI Insights';
                SubPageLink = "No." = field("No.");
            }
        }
    }
}
