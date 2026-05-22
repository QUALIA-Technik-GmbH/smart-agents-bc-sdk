/// <summary>
/// Multi-turn chat surface as a page part. Keeps the same session across turns.
/// </summary>
page 77092 "QUA Conversation Sidebar"
{
    PageType = CardPart;
    Caption = 'Smart Agent';
    SourceTable = "QUA Conversation Turn";
    SourceTableTemporary = true;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Turns)
            {
                ShowCaption = false;
                Editable = false;

                field(Role; Rec.Role)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who produced this message.';
                    Editable = false;
                    Width = 8;
                }
                field(Body; Rec.Body)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the message body.';
                    Editable = false;
                    MultiLine = true;
                }
            }
            group(Input)
            {
                ShowCaption = false;

                field(NextMessage; NextMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Your message';
                    ToolTip = 'Specifies the next message to send to the agent.';
                    MultiLine = true;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendAction)
            {
                ApplicationArea = All;
                Caption = 'Send';
                Image = SendTo;
                ToolTip = 'Send the message to the agent.';

                trigger OnAction()
                begin
                    Send();
                end;
            }
            action(ResetAction)
            {
                ApplicationArea = All;
                Caption = 'New Conversation';
                Image = ClearLog;
                ToolTip = 'Discard the current session and start fresh.';

                trigger OnAction()
                begin
                    Reset();
                end;
            }
        }
    }

    var
        NextMessage: Text;
        SessionId: Guid;
        NoAgentMsg: Label 'Set the Conversation Agent No. on Sales & Receivables Setup to use this sidebar.';
        AgentFailedLbl: Label '(error: %1)', Comment = '%1 = error text';

    procedure SetCustomer(CustNo: Code[20])
    begin
        // Reset turns whenever the parent record changes.
        if Rec.IsTemporary() then begin
            Rec.DeleteAll();
            Clear(SessionId);
            CurrPage.Update(false);
        end;
    end;

    local procedure Send()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SA: Codeunit "QUA Smart Agent SDK";
        Result: JsonObject;
        ErrorText: Text;
        Response: Text;
        Body: Text;
    begin
        if NextMessage = '' then
            exit;

        SalesSetup.Get();
        if SalesSetup."QUA Conversation Agent No." = 0 then begin
            Message(NoAgentMsg);
            exit;
        end;

        Body := NextMessage;
        AppendTurn(Rec.Role::User, Body);
        NextMessage := '';
        CurrPage.Update(false);

        if IsNullGuid(SessionId) then
            Result := SA.SendMessageAndPoll(SalesSetup."QUA Conversation Agent No.", Body, 120000, ErrorText)
        else
            Result := SA.SendMessageAndPollInSession(SalesSetup."QUA Conversation Agent No.", SessionId, Body, 120000, ErrorText);

        if ErrorText <> '' then begin
            AppendTurn(Rec.Role::Agent, StrSubstNo(AgentFailedLbl, ErrorText));
            exit;
        end;

        if IsNullGuid(SessionId) then
            SessionId := SA.GetSessionId(Result);

        Response := SA.GetResponse(Result);
        AppendTurn(Rec.Role::Agent, Response);
    end;

    local procedure AppendTurn(Role: Option User,Agent; Body: Text)
    begin
        Rec.Init();
        Rec.Role := Role;
        Rec.Body := CopyStr(Body, 1, MaxStrLen(Rec.Body));
        Rec.CreatedAt := CurrentDateTime();
        Rec.Insert();
        CurrPage.Update(false);
    end;

    local procedure Reset()
    begin
        Rec.DeleteAll();
        Clear(SessionId);
        NextMessage := '';
        CurrPage.Update(false);
    end;
}
