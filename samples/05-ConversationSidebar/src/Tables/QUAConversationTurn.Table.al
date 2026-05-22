/// <summary>
/// Temp-only record holding one turn of a conversation. The Conversation
/// Sidebar page uses this as its source table.
/// </summary>
table 77091 "QUA Conversation Turn"
{
    Caption = 'Conversation Turn';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; Role; Option)
        {
            Caption = 'Role';
            OptionMembers = User,Agent;
            OptionCaption = 'You,Agent';
        }
        field(20; Body; Text[2048])
        {
            Caption = 'Body';
        }
        field(30; CreatedAt; DateTime)
        {
            Caption = 'Created At';
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
