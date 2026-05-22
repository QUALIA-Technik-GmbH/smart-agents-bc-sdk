/// <summary>
/// Setup page for the Bulk Processor sample.
/// </summary>
page 77074 "QUA Bulk Processor Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "QUA Bulk Processor Setup";
    Caption = 'Bulk Processor Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Smart Agent to query for each customer.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SA: Codeunit "QUA Smart Agent SDK";
                        PickedNo: Integer;
                        PickedName: Text[100];
                    begin
                        if SA.LookupAgent(PickedNo, PickedName) then begin
                            Rec.Validate("Agent No.", PickedNo);
                            exit(true);
                        end;
                        exit(false);
                    end;
                }
                field("Customer Filter"; Rec."Customer Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an optional Customer filter expression. Example: "Country/Region Code=DE".';
                }
                field("Prompt Template"; Rec."Prompt Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the prompt sent for each customer. Use %1 for Customer No. and %2 for Name.';
                    MultiLine = true;
                }
                field("Max Wait (ms)"; Rec."Max Wait (ms)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how long to wait for each agent response before marking the row as failed.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunNow)
            {
                ApplicationArea = All;
                Caption = 'Run Now';
                Image = Start;
                ToolTip = 'Run the bulk processor immediately in the foreground (for testing).';

                trigger OnAction()
                var
                    Job: Codeunit "QUA Bulk Processor Job";
                begin
                    Job.ProcessAll();
                end;
            }
            action(ShowResults)
            {
                ApplicationArea = All;
                Caption = 'Show Results';
                Image = List;
                RunObject = page "QUA Bulk Processor Results";
                ToolTip = 'Open the results list page.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSingleton();
    end;
}
