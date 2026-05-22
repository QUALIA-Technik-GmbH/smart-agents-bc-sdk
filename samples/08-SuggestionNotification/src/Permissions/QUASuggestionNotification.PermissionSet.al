/// <summary>
/// Grants the Suggestion Notification sample access to the SDK, the runner,
/// and the Sales Header.
/// </summary>
permissionset 77153 "QUA Suggestion Notification"
{
    Assignable = true;
    Caption = 'QUA Suggestion Notification';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Suggestion Runner" = X,
        tabledata "Sales Header" = R,
        tabledata "Sales & Receivables Setup" = R;
}
