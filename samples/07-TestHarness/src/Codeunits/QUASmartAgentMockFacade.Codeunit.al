/// <summary>
/// Test-time helper that primes the Smart Agents buffer table with a canned
/// response, so the SDK's CallFacade finds an already-processed row.
/// </summary>
codeunit 77130 "QUA Smart Agent Mock Facade"
{
    Access = Public;

    var
        FacadeTableId: Integer;

    /// <summary>
    /// Write a canned successful response for the next SDK call.
    /// </summary>
    procedure SetSuccessResponse(ResponseJson: Text)
    begin
        WriteRow('', ResponseJson);
    end;

    /// <summary>
    /// Write a canned error response for the next SDK call.
    /// </summary>
    procedure SetErrorResponse(ErrorText: Text)
    begin
        WriteRow(ErrorText, '');
    end;

    local procedure WriteRow(ErrorText: Text; ResponseJson: Text)
    var
        SA: Codeunit "QUA Smart Agent SDK";
        RecRef: RecordRef;
        FldRef: FieldRef;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
    begin
        FacadeTableId := 72778326;

        RecRef.Open(FacadeTableId);
        RecRef.Init();

        FldRef := RecRef.Field(SA.BufferField_Method());
        FldRef.Value := 'MOCK';

        FldRef := RecRef.Field(SA.BufferField_BCSessionId());
        FldRef.Value := Database.SessionId();

        FldRef := RecRef.Field(SA.BufferField_IsProcessed());
        FldRef.Value := true;

        FldRef := RecRef.Field(SA.BufferField_ErrorText());
        FldRef.Value := ErrorText;

        RecRef.Insert(true);

        if ResponseJson <> '' then begin
            TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
            OutStr.WriteText(ResponseJson);
            FldRef := RecRef.Field(SA.BufferField_Response());
            TempBlob.ToFieldRef(FldRef);
            RecRef.Modify();
        end;

        Commit();
        RecRef.Close();
    end;

    /// <summary>Remove any leftover buffer rows produced by previous tests.</summary>
    procedure ClearAll()
    var
        RecRef: RecordRef;
    begin
        FacadeTableId := 72778326;
        RecRef.Open(FacadeTableId);
        RecRef.DeleteAll();
        Commit();
        RecRef.Close();
    end;
}
