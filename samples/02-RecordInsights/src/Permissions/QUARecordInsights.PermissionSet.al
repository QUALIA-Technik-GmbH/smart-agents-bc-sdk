/// <summary>
/// Grants access to the Record Insights FactBox and its async runner.
/// </summary>
permissionset 77034 "QUA Record Insights"
{
    Assignable = true;
    Caption = 'QUA Record Insights';

    Permissions =
        page "QUA Record Insights FactBox" = X,
        codeunit "QUA Record Insights Runner" = X,
        codeunit "QUA Smart Agent SDK" = X,
        tabledata Customer = R,
        tabledata "Sales & Receivables Setup" = R;
}
