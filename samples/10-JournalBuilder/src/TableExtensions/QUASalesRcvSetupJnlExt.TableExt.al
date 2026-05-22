/// <summary>
/// Adds the agent reference and journal target for the Journal Builder sample.
/// </summary>
tableextension 77190 "QUA Journal Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(77190; "QUA Journal Agent No."; Integer)
        {
            Caption = 'Journal Builder Agent No.';
            DataClassification = CustomerContent;
        }
        field(77191; "QUA Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(77192; "QUA Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("QUA Journal Template Name"));
        }
    }
}
