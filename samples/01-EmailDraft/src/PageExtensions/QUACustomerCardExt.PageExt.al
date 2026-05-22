/// <summary>
/// Adds a "Draft Email" action to the Customer Card. The action opens the
/// QUA Email Draft Prompt page, which sends the customer's data plus the
/// user's prompt to the Smart Agent configured on Sales &amp; Receivables Setup.
/// </summary>
pageextension 77012 "QUA Customer Card Ext" extends "Customer Card"
{
    actions
    {
        addlast(processing)
        {
            action(QUADraftEmail)
            {
                ApplicationArea = All;
                Caption = 'Draft Email';
                Image = SendTo;
                ToolTip = 'Open a prompt dialog and let the Smart Agent draft an email for this customer.';

                trigger OnAction()
                var
                    PromptDialog: Page "QUA Email Draft Prompt";
                begin
                    PromptDialog.SetCustomer(Rec);
                    PromptDialog.RunModal();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(QUADraftEmail_Promoted; QUADraftEmail)
            {
            }
        }
    }
}
