/// <summary>
/// List page showing anomalies flagged by the watcher.
/// </summary>
page 77213 "QUA Anomaly Findings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "QUA Anomaly Finding";
    Caption = 'Anomaly Findings';
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Findings)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Detected At"; Rec."Detected At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the watcher detected this anomaly.';
                }
                field(Severity; Rec.Severity)
                {
                    ApplicationArea = All;
                    StyleExpr = SeverityStyleExpr;
                    ToolTip = 'Specifies how serious the anomaly is.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short title for the finding.';
                }
                field("Related Document No."; Rec."Related Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related document no., if any.';
                }
                field(Details; Rec.Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full description of the anomaly.';
                }
                field(Acknowledged; Rec.Acknowledged)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a user has acknowledged this anomaly.';
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
                Caption = 'Scan Now';
                Image = Start;
                ToolTip = 'Run the anomaly scan immediately (for testing).';

                trigger OnAction()
                var
                    Job: Codeunit "QUA Anomaly Watcher Job";
                begin
                    Job.Scan();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        SeverityStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Severity of
            Rec.Severity::Info:
                SeverityStyleExpr := 'Standard';
            Rec.Severity::Warning:
                SeverityStyleExpr := 'Ambiguous';
            Rec.Severity::Critical:
                SeverityStyleExpr := 'Unfavorable';
        end;
    end;
}
