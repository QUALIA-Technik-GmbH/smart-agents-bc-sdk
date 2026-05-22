/// <summary>
/// One anomaly flagged by an Anomaly Watcher scan.
/// </summary>
table 77211 "QUA Anomaly Finding"
{
    Caption = 'Anomaly Finding';
    DataClassification = CustomerContent;
    DrillDownPageId = "QUA Anomaly Findings";
    LookupPageId = "QUA Anomaly Findings";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Detected At"; DateTime)
        {
            Caption = 'Detected At';
        }
        field(20; Severity; Option)
        {
            Caption = 'Severity';
            OptionMembers = Info,Warning,Critical;
            OptionCaption = 'Info,Warning,Critical';
        }
        field(30; Title; Text[150])
        {
            Caption = 'Title';
        }
        field(40; Details; Text[2048])
        {
            Caption = 'Details';
        }
        field(50; "Related Document No."; Code[20])
        {
            Caption = 'Related Document No.';
        }
        field(60; Acknowledged; Boolean)
        {
            Caption = 'Acknowledged';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(BySeverity; Severity, "Detected At")
        {
        }
    }
}
