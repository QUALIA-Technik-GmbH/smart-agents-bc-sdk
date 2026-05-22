/// <summary>
/// Grants the Bulk Processor sample access to the SDK, its own setup/result
/// tables, and the Customer master records.
/// </summary>
permissionset 77076 "QUA Bulk Processor"
{
    Assignable = true;
    Caption = 'QUA Bulk Processor';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Bulk Processor Runner" = X,
        codeunit "QUA Bulk Processor Job" = X,
        page "QUA Bulk Processor Setup" = X,
        page "QUA Bulk Processor Results" = X,
        tabledata "QUA Bulk Processor Setup" = RIMD,
        tabledata "QUA Bulk Processor Result" = RIMD,
        tabledata Customer = R;
}
