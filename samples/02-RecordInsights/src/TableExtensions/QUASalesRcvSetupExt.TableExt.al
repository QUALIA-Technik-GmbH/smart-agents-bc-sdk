/// <summary>
/// Adds a "Record Insights Agent No." reference to "Sales &amp; Receivables Setup".
/// The Record Insights FactBox uses it to know which Smart Agent to ask.
/// </summary>
tableextension 77030 "QUA Insights Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77030; "QUA Record Insights Agent No."; Integer)
        {
            Caption = 'Record Insights Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
