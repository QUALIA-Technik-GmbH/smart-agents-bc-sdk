/// <summary>
/// Grants the Agent Provisioner access to the SDK.
/// </summary>
permissionset 77252 "QUA Agent Provisioner"
{
    Assignable = true;
    Caption = 'QUA Agent Provisioner';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Agent Provisioner" = X,
        page "QUA Agent Provisioner" = X;
}
