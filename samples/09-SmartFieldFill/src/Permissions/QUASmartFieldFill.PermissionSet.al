/// <summary>
/// Grants the Smart Field Fill sample access to the SDK, the engine, and
/// Sales Lines + Items.
/// </summary>
permissionset 77173 "QUA Smart Field Fill"
{
    Assignable = true;
    Caption = 'QUA Smart Field Fill';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Smart Fill Engine" = X,
        tabledata "Sales Line" = RM,
        tabledata Item = R,
        tabledata "Sales & Receivables Setup" = R;
}
