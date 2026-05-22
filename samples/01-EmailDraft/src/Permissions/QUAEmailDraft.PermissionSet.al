/// <summary>
/// Grants access to the Email Draft sample: the prompt dialog page, the SDK
/// codeunit it calls, and the underlying Customer / Sales &amp; Receivables Setup
/// tables read while building context.
/// </summary>
permissionset 77014 "QUA Email Draft"
{
    Assignable = true;
    Caption = 'QUA Email Draft';

    Permissions =
        page "QUA Email Draft Prompt" = X,
        codeunit "QUA Smart Agent SDK" = X,
        tabledata Customer = R,
        tabledata "Sales & Receivables Setup" = R;
}
