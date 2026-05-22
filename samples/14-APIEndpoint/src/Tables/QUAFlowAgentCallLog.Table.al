/// <summary>
/// Audit log of external askAgent calls.
/// </summary>
table 77271 "QUA Flow Agent Call Log"
{
    Caption = 'Flow Agent Call Log';
    DataClassification = CustomerContent;
    DrillDownPageId = "QUA Flow Agent Call Log";
    LookupPageId = "QUA Flow Agent Call Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Called At"; DateTime)
        {
            Caption = 'Called At';
        }
        field(20; "Called By"; Code[50])
        {
            Caption = 'Called By';
        }
        field(30; "Agent No."; Integer)
        {
            Caption = 'Agent No.';
        }
        field(40; "Prompt Excerpt"; Text[250])
        {
            Caption = 'Prompt Excerpt';
        }
        field(50; "Status"; Text[40])
        {
            Caption = 'Status';
        }
        field(60; "Tokens Used"; Integer)
        {
            Caption = 'Tokens Used';
        }
        field(70; "Error Text"; Text[2048])
        {
            Caption = 'Error Text';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
