/// <summary>
/// Adds "Conversation Agent No." to Sales &amp; Receivables Setup for the
/// Customer Card conversation sidebar.
/// </summary>
tableextension 77090 "QUA Conv Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77090; "QUA Conversation Agent No."; Integer)
        {
            Caption = 'Conversation Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
