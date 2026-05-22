/// <summary>
/// Temp source table for the askAgent API page. The page binds to it so that
/// OData can pass arguments through field assignments without creating
/// physical rows.
/// </summary>
table 77270 "QUA Ask Agent Buffer"
{
    Caption = 'Ask Agent Buffer';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Agent No."; Integer)
        {
            Caption = 'Agent No.';
        }
        field(10; Prompt; Text[2048])
        {
            Caption = 'Prompt';
        }
        field(20; Status; Text[40])
        {
            Caption = 'Status';
        }
        field(30; Response; Text[2048])
        {
            Caption = 'Response';
        }
        field(40; "Tokens Used"; Integer)
        {
            Caption = 'Tokens Used';
        }
        field(50; "Error Text"; Text[2048])
        {
            Caption = 'Error Text';
        }
    }

    keys
    {
        key(PK; "Agent No.")
        {
            Clustered = true;
        }
    }
}
