/// <summary>
/// Grants the Approval Recommender access to the SDK and its recommendations table.
/// </summary>
permissionset 77234 "QUA Approval Recommender"
{
    Assignable = true;
    Caption = 'QUA Approval Recommender';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Approval Recommender" = X,
        tabledata "QUA Approval Recommendation" = RIMD,
        tabledata "Approval Entry" = R,
        tabledata "Sales & Receivables Setup" = R;
}
