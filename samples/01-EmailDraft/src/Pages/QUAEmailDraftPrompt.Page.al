/// <summary>
/// PromptDialog launched from the Customer Card. Captures one natural-language
/// instruction and, on Generate, sends the customer context plus the prompt
/// to the Smart Agent configured on Sales &amp; Receivables Setup. The drafted
/// email opens in the BC email editor.
/// </summary>
page 77013 "QUA Email Draft Prompt"
{
    PageType = PromptDialog;
    Extensible = false;
    ApplicationArea = All;
    Caption = 'Draft Email with Smart Agent';
    PromptMode = Prompt;
    IsPreview = true;
    InstructionalText = 'Describe the email you want to send to this customer. The Smart Agent will draft the recipient, subject and body for you to review.';

    layout
    {
        area(Prompt)
        {
            field(UserPrompt; UserPrompt)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Tip: write naturally. For example — "Politely remind the customer about overdue invoices and ask for an updated payment plan."';
                ToolTip = 'Type the natural-language request you want the Smart Agent to act on. The text is sent to the agent along with the customer data.';
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Send your prompt to the Smart Agent and open the drafted email directly in the email editor.';

                trigger OnAction()
                begin
                    GenerateEmail();
                end;
            }
            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Close the dialog.';
            }
        }
    }

    var
        CustomerRec: Record Customer;
        UserPrompt: Text;
        NoAgentConfiguredErr: Label 'No Smart Agent is configured on Sales & Receivables Setup. Set one on the "Email Draft Agent No." field and try again.';
        AgentFailedErr: Label 'The Smart Agent could not draft the email: %1', Comment = '%1 = error text returned by the agent backend';
        PromptTemplateLbl: Label 'Customer No.=%1, Customer Name=%2. In the context of this customer: %3', Locked = true;

    procedure SetCustomer(var SourceCustomer: Record Customer)
    begin
        CustomerRec := SourceCustomer;
    end;

    local procedure GenerateEmail()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SA: Codeunit "QUA Smart Agent SDK";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Result: JsonObject;
        ErrorText: Text;
        FinalPrompt: Text;
        Response: Text;
        ToList: List of [Text];
        CcList: List of [Text];
        BccList: List of [Text];
    begin
        SalesSetup.Get();
        if SalesSetup."QUA Email Draft Agent No." = 0 then
            Error(NoAgentConfiguredErr);

        if CustomerRec."E-Mail" <> '' then
            ToList.Add(CustomerRec."E-Mail");

        FinalPrompt := StrSubstNo(
            PromptTemplateLbl,
            CustomerRec."No.",
            CustomerRec.Name,
            UserPrompt);

        Result := SA.SendMessageAndPoll(
            SalesSetup."QUA Email Draft Agent No.",
            FinalPrompt,
            120000,
            ErrorText);

        if ErrorText <> '' then
            Error(AgentFailedErr, ErrorText);

        Response := SA.GetResponse(Result);
        EmailMessage.Create(ToList, '', Response, true, CcList, BccList);
        Email.OpenInEditor(EmailMessage);
        CurrPage.Close();
    end;
}
