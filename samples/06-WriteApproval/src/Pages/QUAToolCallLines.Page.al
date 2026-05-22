/// <summary>
/// Repeater part showing the agent's proposed tool calls.
/// </summary>
page 77114 "QUA Tool Call Lines"
{
    PageType = ListPart;
    Caption = 'Tool Calls';
    SourceTable = "QUA Tool Call Display";
    SourceTableTemporary = true;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BC tool function the agent intends to call.';
                }
                field("Entity Name"; Rec."Entity Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entity (table or page) the tool call targets.';
                }
                field(Arguments; Rec.Arguments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the JSON arguments the agent will pass.';
                }
            }
        }
    }

    procedure ClearLines()
    begin
        Rec.DeleteAll();
        CurrPage.Update(false);
    end;

    procedure AppendLine(var SourceRec: Record "QUA Tool Call Display" temporary)
    begin
        Rec.Init();
        Rec.TransferFields(SourceRec, false);
        Rec.Insert();
        CurrPage.Update(false);
    end;

    procedure RowCount(): Integer
    begin
        exit(Rec.Count);
    end;
}
