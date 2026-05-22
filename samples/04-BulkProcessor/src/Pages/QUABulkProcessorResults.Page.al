/// <summary>
/// Read-only list of bulk processor outputs.
/// </summary>
page 77075 "QUA Bulk Processor Results"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "QUA Bulk Processor Result";
    Caption = 'Bulk Processor Results';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    SourceTableView = sorting("Entry No.") order(descending);
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Results)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result entry number.';
                }
                field("Run Started At"; Rec."Run Started At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the run that produced this row started.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer this result is for.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the agent call succeeded.';
                }
                field("Tokens Used"; Rec."Tokens Used")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total tokens consumed by the agent for this row.';
                }
                field("Response Excerpt"; Rec."Response Excerpt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the beginning of the agent response.';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error text (if Status = Failed).';
                }
            }
        }
    }
}
