/// <summary>
/// Grants the test harness access to the SDK and the mock helper.
/// </summary>
permissionset 77132 "QUA Test Harness"
{
    Assignable = true;
    Caption = 'QUA Test Harness';

    Permissions =
        codeunit "QUA Smart Agent SDK" = X,
        codeunit "QUA Smart Agent Mock Facade" = X,
        codeunit "QUA SDK Tests" = X;
}
