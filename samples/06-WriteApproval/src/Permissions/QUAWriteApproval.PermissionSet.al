/// <summary>
/// Grants the Write Approval sample access to the SDK, the reviewer, the pages,
/// and the display temp table.
/// </summary>
permissionset 77115 "QUA Write Approval"
{
    Assignable = true;
    Caption = 'QUA Write Approval';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Tool Call Reviewer" = X,
        page "QUA Write Approval" = X,
        page "QUA Tool Call Lines" = X,
        tabledata "QUA Tool Call Display" = RIMD,
        tabledata "Sales & Receivables Setup" = R;
}
