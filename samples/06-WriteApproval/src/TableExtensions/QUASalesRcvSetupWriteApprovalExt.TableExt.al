/// <summary>
/// Adds the agent reference for the Write Approval sample.
/// </summary>
tableextension 77110 "QUA Write Approval Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77110; "QUA Write Approval Agent No."; Integer)
        {
            Caption = 'Write Approval Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
