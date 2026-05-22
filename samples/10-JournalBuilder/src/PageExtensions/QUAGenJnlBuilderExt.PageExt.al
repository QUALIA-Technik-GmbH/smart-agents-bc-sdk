/// <summary>
/// Adds the "Build from Text" action to the General Journal page.
/// </summary>
pageextension 77193 "QUA Gen Jnl Builder Ext" extends "General Journal"
{
    actions
    {
        addlast(processing)
        {
            action(QUABuildFromText)
            {
                ApplicationArea = All;
                Caption = 'Build from Text';
                Image = SparkleFilled;
                ToolTip = 'Open a prompt dialog and let the Smart Agent draft journal lines for the configured template + batch.';

                trigger OnAction()
                var
                    PromptDialog: Page "QUA Journal Builder Prompt";
                begin
                    PromptDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(QUABuildFromText_Promoted; QUABuildFromText)
            {
            }
        }
    }
}
