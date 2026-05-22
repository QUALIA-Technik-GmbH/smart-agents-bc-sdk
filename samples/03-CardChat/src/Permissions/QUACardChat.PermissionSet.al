/// <summary>
/// Grants the Card Chat action access to the SDK and the setup record.
/// </summary>
permissionset 77054 "QUA Card Chat"
{
    Assignable = true;
    Caption = 'QUA Card Chat';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        tabledata "Sales & Receivables Setup" = R;
}
