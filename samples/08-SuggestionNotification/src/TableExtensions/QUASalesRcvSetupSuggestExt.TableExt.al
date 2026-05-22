/// <summary>
/// Adds the agent reference for the Suggestion Notification sample.
/// </summary>
tableextension 77150 "QUA Suggestion Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77150; "QUA Suggestion Agent No."; Integer)
        {
            Caption = 'Suggestion Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
