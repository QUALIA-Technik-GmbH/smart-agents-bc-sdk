/// <summary>
/// User-driven write approval page. Sends a prompt, surfaces any tool calls
/// the agent wants to perform, lets the user approve or reject them.
/// </summary>
page 77112 "QUA Write Approval"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Agent Write Approval';
    SourceTable = "QUA Tool Call Display";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(Prompt)
            {
                Caption = 'Your instruction';

                field(UserPrompt; UserPrompt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    MultiLine = true;
                    ToolTip = 'Type the instruction you want the agent to perform.';
                    Editable = NoRequestInFlight;
                }
            }
            group(StatusGroup)
            {
                Caption = 'Status';

                field(StatusText; StatusText)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Specifies where in the flow the agent currently is.';
                }
            }
            part(ToolCalls; "QUA Tool Call Lines")
            {
                ApplicationArea = All;
                Caption = 'Proposed tool calls';
                SubPageView = sorting("Entry No.");
            }
            group(ResponseGroup)
            {
                Caption = 'Final response';
                Visible = ResponseVisible;

                field(FinalResponse; FinalResponse)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Specifies the agent''s final response after approval / rejection.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Caption = 'Submit';
                Image = SendTo;
                Enabled = NoRequestInFlight;
                ToolTip = 'Send the instruction to the agent.';

                trigger OnAction()
                begin
                    Submit();
                end;
            }
            action(ApproveAction)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Enabled = HasPendingToolCalls;
                ToolTip = 'Approve all proposed tool calls and let the agent finish.';

                trigger OnAction()
                begin
                    Approve();
                end;
            }
            action(RejectAction)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Enabled = HasPendingToolCalls;
                ToolTip = 'Reject all proposed tool calls. The agent will finish without writing.';

                trigger OnAction()
                begin
                    Reject();
                end;
            }
            action(NewRequest)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = NewDocument;
                ToolTip = 'Discard the current request and start over.';

                trigger OnAction()
                begin
                    ResetState();
                end;
            }
        }
    }

    var
        UserPrompt: Text;
        StatusText: Text;
        FinalResponse: Text;
        ActiveRequestId: Text;
        NoRequestInFlight: Boolean;
        HasPendingToolCalls: Boolean;
        ResponseVisible: Boolean;
        NoAgentErr: Label 'Set the Write Approval Agent No. on Sales & Receivables Setup to use this page.';
        StatusReadyMsg: Label 'Ready.';
        StatusSendingMsg: Label 'Sending and waiting for confirmation…';
        StatusAwaitingMsg: Label 'Waiting for your decision.';
        StatusApprovingMsg: Label 'Approving and waiting for the agent to finish…';
        StatusRejectingMsg: Label 'Rejecting and waiting for the agent to finish…';
        StatusDoneMsg: Label 'Completed.';
        StatusFailedLbl: Label 'Failed: %1', Comment = '%1 = error text';

    trigger OnOpenPage()
    begin
        ResetState();
    end;

    local procedure Submit()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Reviewer: Codeunit "QUA Tool Call Reviewer";
        ToolCalls: JsonArray;
        ErrorText: Text;
    begin
        SalesSetup.Get();
        if SalesSetup."QUA Write Approval Agent No." = 0 then
            Error(NoAgentErr);

        NoRequestInFlight := false;
        StatusText := StatusSendingMsg;
        CurrPage.Update(false);

        if not Reviewer.SendUntilConfirmation(
                SalesSetup."QUA Write Approval Agent No.",
                UserPrompt,
                ActiveRequestId,
                ToolCalls,
                ErrorText)
        then begin
            ShowError(ErrorText);
            exit;
        end;

        if ToolCalls.Count > 0 then begin
            PopulateToolCalls(ToolCalls);
            StatusText := StatusAwaitingMsg;
            HasPendingToolCalls := true;
        end else begin
            StatusText := StatusDoneMsg;
            NoRequestInFlight := true;
        end;
        CurrPage.Update(false);
    end;

    local procedure Approve()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Reviewer: Codeunit "QUA Tool Call Reviewer";
        SA: Codeunit "QUA Smart Agent SDK";
        FinalResult: JsonObject;
        ErrorText: Text;
    begin
        SalesSetup.Get();
        HasPendingToolCalls := false;
        StatusText := StatusApprovingMsg;
        CurrPage.Update(false);

        if not Reviewer.ApproveAndWait(
                SalesSetup."QUA Write Approval Agent No.",
                ActiveRequestId,
                FinalResult,
                ErrorText)
        then begin
            ShowError(ErrorText);
            exit;
        end;

        FinalResponse := SA.GetResponse(FinalResult);
        ResponseVisible := true;
        StatusText := StatusDoneMsg;
        NoRequestInFlight := true;
        CurrPage.Update(false);
    end;

    local procedure Reject()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Reviewer: Codeunit "QUA Tool Call Reviewer";
        SA: Codeunit "QUA Smart Agent SDK";
        FinalResult: JsonObject;
        ErrorText: Text;
    begin
        SalesSetup.Get();
        HasPendingToolCalls := false;
        StatusText := StatusRejectingMsg;
        CurrPage.Update(false);

        if not Reviewer.RejectAndWait(
                SalesSetup."QUA Write Approval Agent No.",
                ActiveRequestId,
                FinalResult,
                ErrorText)
        then begin
            ShowError(ErrorText);
            exit;
        end;

        FinalResponse := SA.GetResponse(FinalResult);
        ResponseVisible := true;
        StatusText := StatusDoneMsg;
        NoRequestInFlight := true;
        CurrPage.Update(false);
    end;

    local procedure PopulateToolCalls(ToolCalls: JsonArray)
    var
        DisplayRec: Record "QUA Tool Call Display" temporary;
        Token: JsonToken;
        Obj: JsonObject;
        ValueToken: JsonToken;
        i: Integer;
        ArgsText: Text;
    begin
        CurrPage.ToolCalls.Page.ClearLines();

        for i := 0 to ToolCalls.Count - 1 do begin
            ToolCalls.Get(i, Token);
            Obj := Token.AsObject();
            Clear(DisplayRec);
            DisplayRec.Init();
            DisplayRec."Entry No." := i + 1;
            if Obj.Get('functionName', ValueToken) then
                DisplayRec."Function Name" := CopyStr(ValueToken.AsValue().AsText(), 1, MaxStrLen(DisplayRec."Function Name"));
            if Obj.Get('entityName', ValueToken) then
                DisplayRec."Entity Name" := CopyStr(ValueToken.AsValue().AsText(), 1, MaxStrLen(DisplayRec."Entity Name"));
            if Obj.Get('arguments', ValueToken) then begin
                ValueToken.AsObject().WriteTo(ArgsText);
                DisplayRec.Arguments := CopyStr(ArgsText, 1, MaxStrLen(DisplayRec.Arguments));
            end;
            CurrPage.ToolCalls.Page.AppendLine(DisplayRec);
        end;
    end;

    local procedure ResetState()
    begin
        UserPrompt := '';
        StatusText := StatusReadyMsg;
        FinalResponse := '';
        ActiveRequestId := '';
        NoRequestInFlight := true;
        HasPendingToolCalls := false;
        ResponseVisible := false;
        if CurrPage.ToolCalls.Page.RowCount() > 0 then
            CurrPage.ToolCalls.Page.ClearLines();
        CurrPage.Update(false);
    end;

    local procedure ShowError(ErrorText: Text)
    begin
        StatusText := StrSubstNo(StatusFailedLbl, ErrorText);
        HasPendingToolCalls := false;
        NoRequestInFlight := true;
        CurrPage.Update(false);
    end;
}
