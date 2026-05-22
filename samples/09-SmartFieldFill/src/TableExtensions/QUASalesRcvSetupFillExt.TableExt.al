/// <summary>
/// Adds the agent reference for the Smart Field Fill sample.
/// </summary>
tableextension 77170 "QUA Smart Fill Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77170; "QUA Smart Fill Agent No."; Integer)
        {
            Caption = 'Smart Fill Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
