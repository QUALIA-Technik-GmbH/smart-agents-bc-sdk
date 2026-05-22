/// <summary>
/// Grants the Journal Builder sample access to journal data and the SDK.
/// </summary>
permissionset 77194 "QUA Journal Builder"
{
    Assignable = true;
    Caption = 'QUA Journal Builder';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Journal Line Builder" = X,
        page "QUA Journal Builder Prompt" = X,
        tabledata "Gen. Journal Line" = RIMD,
        tabledata "Gen. Journal Template" = R,
        tabledata "Gen. Journal Batch" = R,
        tabledata "Sales & Receivables Setup" = R;
}
