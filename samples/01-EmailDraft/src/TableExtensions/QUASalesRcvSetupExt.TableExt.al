/// <summary>
/// Adds a Smart Agent reference to "Sales &amp; Receivables Setup" so the
/// Draft Email action on the Customer Card knows which agent to call.
/// </summary>
tableextension 77010 "QUA Sales Rcv Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77010; "QUA Email Draft Agent No."; Integer)
        {
            Caption = 'Email Draft Agent No.';
            DataClassification = CustomerContent;
        }
    }
}
