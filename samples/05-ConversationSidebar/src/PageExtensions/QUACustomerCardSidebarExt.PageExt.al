/// <summary>
/// Embeds the Conversation Sidebar in the Customer Card.
/// </summary>
pageextension 77093 "QUA Customer Card Sidebar" extends "Customer Card"
{
    layout
    {
        addlast(factboxes)
        {
            part(QUAConversation; "QUA Conversation Sidebar")
            {
                ApplicationArea = All;
                Caption = 'Smart Agent';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.QUAConversation.Page.SetCustomer(Rec."No.");
    end;
}
