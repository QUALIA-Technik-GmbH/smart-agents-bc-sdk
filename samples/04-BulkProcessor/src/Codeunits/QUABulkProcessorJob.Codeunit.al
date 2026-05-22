/// <summary>
/// Job Queue–runnable orchestrator. Reads the singleton setup, iterates
/// matching customers, delegates each one to the per-record runner.
/// </summary>
codeunit 77073 "QUA Bulk Processor Job"
{
    Access = Public;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ProcessAll();
    end;

    procedure ProcessAll()
    var
        Setup: Record "QUA Bulk Processor Setup";
        Customer: Record Customer;
        Runner: Codeunit "QUA Bulk Processor Runner";
        RunStartedAt: DateTime;
        NoSetupErr: Label 'Bulk Processor setup is incomplete: pick an Agent No. and a Prompt Template.';
    begin
        Setup.GetSingleton();
        if (Setup."Agent No." = 0) or (Setup."Prompt Template" = '') then
            Error(NoSetupErr);

        RunStartedAt := CurrentDateTime();

        if Setup."Customer Filter" <> '' then
            Customer.SetView(Setup."Customer Filter");

        if not Customer.FindSet() then
            exit;

        repeat
            Runner.ProcessOne(Customer, Setup, RunStartedAt);
        until Customer.Next() = 0;
    end;
}
