/// <summary>
/// Grants the API Endpoint access to the SDK and its audit log table.
/// External callers must hold this permission set to use the askAgent API.
/// </summary>
permissionset 77275 "QUA API Endpoint"
{
    Assignable = true;
    Caption = 'QUA API Endpoint';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Flow Agent Bridge" = X,
        page "QUA Ask Agent API" = X,
        page "QUA Flow Agent Call Log" = X,
        tabledata "QUA Ask Agent Buffer" = RIMD,
        tabledata "QUA Flow Agent Call Log" = RI;
}
