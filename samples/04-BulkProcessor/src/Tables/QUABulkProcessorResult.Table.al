/// <summary>
/// One row per (run, customer) pair holding the Smart Agent's answer plus
/// telemetry (tokens, status, error if any).
/// </summary>
table 77071 "QUA Bulk Processor Result"
{
    Caption = 'Bulk Processor Result';
    DataClassification = CustomerContent;
    DrillDownPageId = "QUA Bulk Processor Results";
    LookupPageId = "QUA Bulk Processor Results";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Run Started At"; DateTime)
        {
            Caption = 'Run Started At';
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(30; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(40; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,Completed,Failed;
            OptionCaption = 'Pending,Completed,Failed';
        }
        field(50; "Response Excerpt"; Text[2048])
        {
            Caption = 'Response Excerpt';
        }
        field(60; "Tokens Used"; Integer)
        {
            Caption = 'Tokens Used';
        }
        field(70; "Error Text"; Text[2048])
        {
            Caption = 'Error Text';
        }
        field(80; "Full Response"; Blob)
        {
            Caption = 'Full Response';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ByRun; "Run Started At", "Customer No.")
        {
        }
    }
}
