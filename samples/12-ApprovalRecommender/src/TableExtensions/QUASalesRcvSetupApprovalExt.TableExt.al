/// <summary>
/// Adds the agent reference for the Approval Recommender sample.
/// </summary>
tableextension 77230 "QUA Approval Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77230; "QUA Approval Agent No."; Integer)
        {
            Caption = 'Approval Recommender Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
