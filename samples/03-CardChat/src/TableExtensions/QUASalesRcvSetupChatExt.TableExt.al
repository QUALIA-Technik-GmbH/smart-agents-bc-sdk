/// <summary>
/// Adds "Card Chat Agent No." to "Sales &amp; Receivables Setup". The Ask AI
/// action on the Item / Vendor / Sales Quote cards uses this agent.
/// </summary>
tableextension 77050 "QUA Card Chat Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77050; "QUA Card Chat Agent No."; Integer)
        {
            Caption = 'Card Chat Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
