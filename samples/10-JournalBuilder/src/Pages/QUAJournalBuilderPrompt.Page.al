/// <summary>
/// PromptDialog that takes free text and asks the Journal Line Builder to
/// turn it into journal lines.
/// </summary>
page 77192 "QUA Journal Builder Prompt"
{
    PageType = PromptDialog;
    Extensible = false;
    ApplicationArea = All;
    Caption = 'Build Journal Lines from Text';
    PromptMode = Prompt;
    IsPreview = true;
    InstructionalText = 'Paste a free-text description and the Smart Agent will draft journal lines on the configured batch.';

    layout
    {
        area(Prompt)
        {
            field(UserPrompt; UserPrompt)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Example: "Office supplies €234.50 paid by credit card on 2026-03-12, posted to account 6300."';
                ToolTip = 'Type the natural-language description the agent should convert into journal lines.';
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Build';
                ToolTip = 'Send the description to the Smart Agent and create the resulting journal lines.';

                trigger OnAction()
                var
                    Builder: Codeunit "QUA Journal Line Builder";
                begin
                    Builder.BuildFromText(UserPrompt);
                    CurrPage.Close();
                end;
            }
            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Close the dialog without creating lines.';
            }
        }
    }

    var
        UserPrompt: Text;
}
