/// <summary>
/// Singleton setup record for the Bulk Processor: which agent to call, which
/// customer subset to process, and the prompt template.
/// </summary>
table 77070 "QUA Bulk Processor Setup"
{
    Caption = 'Bulk Processor Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Agent No."; Integer)
        {
            Caption = 'Agent No.';
        }
        field(20; "Customer Filter"; Text[250])
        {
            Caption = 'Customer Filter';
            ToolTip = 'Optional Customer record filter, e.g. "Country/Region Code=DE".';
        }
        field(30; "Prompt Template"; Text[2048])
        {
            Caption = 'Prompt Template';
            ToolTip = 'Prompt with %1 (Customer No.) and %2 (Customer Name) placeholders.';
        }
        field(40; "Max Wait (ms)"; Integer)
        {
            Caption = 'Max Wait (ms)';
            InitValue = 120000;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSingleton(): Boolean
    begin
        if not Get('') then begin
            Init();
            "Primary Key" := '';
            Insert();
        end;
        exit(true);
    end;
}
