/// <summary>
/// Exercises the full agent CRUD surface in a single procedure. Builds a
/// "Sales Assistant" agent with Customer + Sales Header data sources, a
/// public help URL, and the current user as an authorized user.
/// </summary>
codeunit 77250 "QUA Agent Provisioner"
{
    Access = Public;

    var
        InstructionsLbl: Label 'You are a Sales Assistant. Use the Customer (18) and Sales Header (36) tables to answer questions about open opportunities, quotes, and overdue invoices. Be concise.', Locked = true;
        DescriptionLbl: Label 'Sample sales assistant provisioned by the Agent Provisioner.';
        AgentNameLbl: Label 'Sales Assistant';
        CreateFailedErr: Label 'Failed to create the agent: %1', Comment = '%1 = error text';
        StepFailedErr: Label 'Failed at step "%1": %2', Comment = '%1 = step name, %2 = error text';
        SuccessLbl: Label 'Smart Agent %1 created and activated.', Comment = '%1 = agent no.';

    procedure ProvisionSalesAssistant(): Integer
    var
        SA: Codeunit "QUA Smart Agent SDK";
        AgentNo: Integer;
        ErrorText: Text;
    begin
        AgentNo := SA.CreateAgent(AgentNameLbl, DescriptionLbl, 'Fast', InstructionsLbl, ErrorText);
        if (AgentNo = 0) or (ErrorText <> '') then
            Error(CreateFailedErr, ErrorText);

        SA.SetAgentCapabilities(AgentNo, true, false, true, false, ErrorText);
        FailIfError('SetAgentCapabilities', ErrorText);

        SA.SetAgentAutonomy(AgentNo, 2, ErrorText);
        FailIfError('SetAgentAutonomy', ErrorText);

        SA.AddDataSource(
            AgentNo,
            'Customers (Table 18)',
            'Default',
            'Look up customer master records by No. or Name.',
            ErrorText);
        FailIfError('AddDataSource Customers', ErrorText);

        SA.AddDataSource(
            AgentNo,
            'Sales Headers (Table 36)',
            'Default',
            'Read Sales Headers for open quotes, orders, and invoices.',
            ErrorText);
        FailIfError('AddDataSource Sales Headers', ErrorText);

        SA.AddToolLink(
            AgentNo,
            'BC Sales Help',
            'https://learn.microsoft.com/dynamics365/business-central/sales-manage-sales',
            'Cite this page when explaining Sales features.',
            ErrorText);
        FailIfError('AddToolLink', ErrorText);

        SA.AddAuthorizedUser(AgentNo, UserId(), ErrorText);
        FailIfError('AddAuthorizedUser', ErrorText);

        SA.ActivateAgent(AgentNo, ErrorText);
        FailIfError('ActivateAgent', ErrorText);

        Message(SuccessLbl, AgentNo);
        exit(AgentNo);
    end;

    local procedure FailIfError(Step: Text; ErrorText: Text)
    begin
        if ErrorText <> '' then
            Error(StepFailedErr, Step, ErrorText);
    end;
}
