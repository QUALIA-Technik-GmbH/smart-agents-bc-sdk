/// <summary>
/// Temp-only display table for the proposed tool calls list.
/// </summary>
table 77113 "QUA Tool Call Display"
{
    Caption = 'Tool Call Display';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Function Name"; Text[50])
        {
            Caption = 'Function';
        }
        field(20; "Entity Name"; Text[100])
        {
            Caption = 'Entity';
        }
        field(30; Arguments; Text[2048])
        {
            Caption = 'Arguments';
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
