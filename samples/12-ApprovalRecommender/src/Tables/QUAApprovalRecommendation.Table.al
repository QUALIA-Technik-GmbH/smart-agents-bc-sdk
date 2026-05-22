/// <summary>
/// One recommendation per Approval Entry, keyed by Entry No.
/// </summary>
table 77231 "QUA Approval Recommendation"
{
    Caption = 'AI Approval Recommendation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Approval Entry No."; Integer)
        {
            Caption = 'Approval Entry No.';
            TableRelation = "Approval Entry"."Entry No.";
        }
        field(10; Decision; Option)
        {
            Caption = 'Decision';
            OptionMembers = Approve,Reject,Hold;
            OptionCaption = 'Approve,Reject,Hold';
        }
        field(20; Reason; Text[2048])
        {
            Caption = 'Reason';
        }
        field(30; "Generated At"; DateTime)
        {
            Caption = 'Generated At';
        }
    }

    keys
    {
        key(PK; "Approval Entry No.")
        {
            Clustered = true;
        }
    }
}
