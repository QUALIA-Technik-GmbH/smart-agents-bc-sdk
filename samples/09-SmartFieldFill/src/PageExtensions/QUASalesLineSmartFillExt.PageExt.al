/// <summary>
/// Adds an Auto-Fill action to the Sales Order Subform.
/// </summary>
pageextension 77172 "QUA Sales Line Smart Fill" extends "Sales Order Subform"
{
    actions
    {
        addlast("&Line")
        {
            action(QUAAutoFill)
            {
                ApplicationArea = All;
                Caption = 'Auto-Fill';
                Image = SparkleFilled;
                ToolTip = 'Use the Smart Agent to translate the Description into Item No. and Quantity on this line.';

                trigger OnAction()
                var
                    Engine: Codeunit "QUA Smart Fill Engine";
                begin
                    Engine.AutoFill(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
