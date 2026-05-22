/// <summary>
/// Adds the agent reference for the Anomaly Watcher sample.
/// </summary>
tableextension 77210 "QUA Anomaly Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77210; "QUA Anomaly Agent No."; Integer)
        {
            Caption = 'Anomaly Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
