/// <summary>
/// Grants the Anomaly Watcher access to the SDK, its results table, and G/L data.
/// </summary>
permissionset 77214 "QUA Anomaly Watcher"
{
    Assignable = true;
    Caption = 'QUA Anomaly Watcher';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Anomaly Watcher Job" = X,
        page "QUA Anomaly Findings" = X,
        tabledata "QUA Anomaly Finding" = RIMD,
        tabledata "G/L Entry" = R,
        tabledata "Sales & Receivables Setup" = R;
}
