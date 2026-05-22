/// <summary>
/// Grants the Conversation Sidebar access to its source temp table and the SDK.
/// </summary>
permissionset 77094 "QUA Conversation Sidebar"
{
    Assignable = true;
    Caption = 'QUA Conversation Sidebar';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        page "QUA Conversation Sidebar" = X,
        tabledata "QUA Conversation Turn" = RIMD,
        tabledata "Sales & Receivables Setup" = R;
}
