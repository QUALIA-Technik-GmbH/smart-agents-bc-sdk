/// <summary>
/// Action page that drives the Agent Provisioner.
/// </summary>
page 77251 "QUA Agent Provisioner"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Smart Agent Provisioner';
    SourceTable = Integer;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(Info)
            {
                Caption = 'About';

                field(InfoText; InfoText)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Describes what the Provision Sales Assistant action does.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProvisionSalesAssistant)
            {
                ApplicationArea = All;
                Caption = 'Provision Sales Assistant';
                Image = NewDocument;
                ToolTip = 'Create and activate a sample sales assistant agent in one click.';

                trigger OnAction()
                var
                    Provisioner: Codeunit "QUA Agent Provisioner";
                begin
                    Provisioner.ProvisionSalesAssistant();
                end;
            }
        }
    }

    var
        InfoText: Text;
        InfoLbl: Label 'Click "Provision Sales Assistant" to create a fully configured Smart Agent: ' +
                       'Customer + Sales Header data sources, a BC help tool link, the current user authorized, ' +
                       'medium autonomy, BC Data Access + Web Search capabilities. The agent is created in Draft, ' +
                       'fully configured, and then activated.';

    trigger OnOpenPage()
    begin
        InfoText := InfoLbl;
    end;
}
