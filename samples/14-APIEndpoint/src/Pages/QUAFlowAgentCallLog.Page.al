/// <summary>
/// Read-only list of external askAgent calls for audit.
/// </summary>
page 77274 "QUA Flow Agent Call Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "QUA Flow Agent Call Log";
    Caption = 'Flow Agent Call Log';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Logs)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the call entry number.';
                }
                field("Called At"; Rec."Called At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the external call arrived.';
                }
                field("Called By"; Rec."Called By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BC user the external caller authenticated as.';
                }
                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the agent the caller requested.';
                }
                field("Prompt Excerpt"; Rec."Prompt Excerpt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the first portion of the prompt.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the agent status after the call.';
                }
                field("Tokens Used"; Rec."Tokens Used")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total tokens consumed.';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error text if the call failed.';
                }
            }
        }
    }
}
