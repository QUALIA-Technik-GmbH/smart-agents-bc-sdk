/// <summary>
/// Surfaces the Email Draft Agent No. on Sales &amp; Receivables Setup and
/// exposes a one-click action to provision a ready-to-use agent.
/// </summary>
pageextension 77011 "QUA Sales Rcv Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("QUA Email Draft Agent No."; Rec."QUA Email Draft Agent No.")
            {
                ApplicationArea = All;
                Caption = 'Email Draft Agent No.';
                ToolTip = 'Specifies the Smart Agent that the Draft Email action on the Customer Card will send prompts to.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    SA: Codeunit "QUA Smart Agent SDK";
                    PickedNo: Integer;
                    PickedName: Text[100];
                begin
                    if SA.LookupAgent(PickedNo, PickedName) then begin
                        Rec.Validate("QUA Email Draft Agent No.", PickedNo);
                        exit(true);
                    end;
                    exit(false);
                end;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(QUACreateEmailDraftAgent)
            {
                ApplicationArea = All;
                Caption = 'Create Email Draft Smart Agent';
                Image = NewDocument;
                ToolTip = 'Create a new Smart Agent for drafting customer emails, attach Customer and Customer Ledger Entries as data sources, activate it, and store its number in this setup.';

                trigger OnAction()
                begin
                    CreateEmailDraftAgent();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(QUACreateEmailDraftAgent_Promoted; QUACreateEmailDraftAgent)
            {
            }
        }
    }

    local procedure CreateEmailDraftAgent()
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Instructions: Text;
        ErrorText: Text;
        AgentNo: Integer;
        ConfirmReplaceMsg: Label 'A Smart Agent (No. %1) is already configured. Create a new one and replace it?', Comment = '%1 = current Smart Agent No.';
        SuccessMsg: Label 'Smart Agent %1 created, activated, and assigned.', Comment = '%1 = new Smart Agent No.';
        CreateFailedErr: Label 'Failed to create Smart Agent: %1', Comment = '%1 = error text';
        CapabilitiesFailedErr: Label 'Failed to set agent capabilities: %1', Comment = '%1 = error text';
        DataSourceFailedErr: Label 'Failed to add data source "%1": %2', Comment = '%1 = data source name, %2 = error text';
        ActivateFailedErr: Label 'Failed to activate Smart Agent %1: %2', Comment = '%1 = agent number, %2 = error text';
    begin
        if Rec."QUA Email Draft Agent No." <> 0 then
            if not Confirm(ConfirmReplaceMsg, false, Rec."QUA Email Draft Agent No.") then
                exit;

        Instructions :=
            'You only draft emails based on the user request. ' +
            'You will always receive a Customer No. or Name from the user; use it to look up the customer ' +
            'and related Customer Ledger Entries. Use information from those tables and print real Business Central ' +
            'data in the email. Draft a polite and professional message.';

        AgentNo := SA.CreateAgent(
            'Email Draft Agent',
            'Drafts customer emails using Customer (18) and Customer Ledger Entries (21) data.',
            'Fast',
            Instructions,
            ErrorText);
        if (AgentNo = 0) or (ErrorText <> '') then
            Error(CreateFailedErr, ErrorText);

        SA.SetAgentCapabilities(AgentNo, true, false, false, false, ErrorText);
        if ErrorText <> '' then
            Error(CapabilitiesFailedErr, ErrorText);

        SA.AddDataSource(
            AgentNo,
            'Customer (Table 18)',
            'Default',
            'Search Customer (18) by No. or Name to locate the customer the user referenced.',
            ErrorText);
        if ErrorText <> '' then
            Error(DataSourceFailedErr, 'Customer (Table 18)', ErrorText);

        SA.AddDataSource(
            AgentNo,
            'Customer Ledger Entries (Table 21)',
            'Default',
            'Read Customer Ledger Entries (21) filtered by the located customer for document numbers, amounts, due dates, and open balances.',
            ErrorText);
        if ErrorText <> '' then
            Error(DataSourceFailedErr, 'Customer Ledger Entries (Table 21)', ErrorText);

        SA.ActivateAgent(AgentNo, ErrorText);
        if ErrorText <> '' then
            Error(ActivateFailedErr, AgentNo, ErrorText);

        Rec.Validate("QUA Email Draft Agent No.", AgentNo);
        Rec.Modify(true);
        CurrPage.Update(false);

        Message(SuccessMsg, AgentNo);
    end;
}
