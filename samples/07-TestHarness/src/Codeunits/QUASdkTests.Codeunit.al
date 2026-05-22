/// <summary>
/// Demonstrates writing AL tests that exercise the SDK without calling the
/// real Smart Agents backend. The mock seeds canned rows into the buffer
/// table so each test is deterministic.
/// </summary>
codeunit 77131 "QUA SDK Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure GetResponse_ReturnsParsedResponseText()
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Mock: Codeunit "QUA Smart Agent Mock Facade";
        Result: JsonObject;
        ErrorText: Text;
    begin
        // [GIVEN] the mock returns a successful response
        Mock.ClearAll();
        Mock.SetSuccessResponse('{"status":"completed","response":"Top customer is C00010","sessionId":"00000000-0000-0000-0000-000000000001","tokensUsed":42,"creditsUsed":0.01}');

        // [WHEN] SDK is asked to send a message
        Result := SA.SendMessageAndPoll(1, 'top customer', ErrorText);

        // [THEN] result helpers parse the canned response
        Assert.AreEqual('', ErrorText, 'No error expected');
        Assert.AreEqual('completed', SA.GetStatus(Result), 'Status should pass through');
        Assert.AreEqual('Top customer is C00010', SA.GetResponse(Result), 'Response should pass through');
        Assert.AreEqual(42, SA.GetTokensUsed(Result), 'Tokens should pass through');
    end;

    [Test]
    procedure SetErrorResponse_PopulatesErrorText()
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Mock: Codeunit "QUA Smart Agent Mock Facade";
        Result: JsonObject;
        ErrorText: Text;
    begin
        // [GIVEN] the mock returns an error
        Mock.ClearAll();
        Mock.SetErrorResponse('Agent not found');

        // [WHEN] SDK is asked to send a message
        Result := SA.SendMessageAndPoll(999, 'whatever', ErrorText);

        // [THEN] ErrorText is filled and response is empty
        Assert.AreEqual('Agent not found', ErrorText, 'Error text should pass through');
        Assert.AreEqual('', SA.GetResponse(Result), 'Response should be empty on error');
    end;

    [Test]
    procedure GetSessionId_ReturnsEmptyGuid_OnMalformedInput()
    var
        SA: Codeunit "QUA Smart Agent SDK";
        Mock: Codeunit "QUA Smart Agent Mock Facade";
        Result: JsonObject;
        ErrorText: Text;
        SessionId: Guid;
    begin
        // [GIVEN] the mock returns a malformed sessionId
        Mock.ClearAll();
        Mock.SetSuccessResponse('{"status":"completed","response":"ok","sessionId":"not-a-guid"}');

        // [WHEN] SDK is asked to send a message
        Result := SA.SendMessageAndPoll(1, 'hi', ErrorText);

        // [THEN] GetSessionId returns an empty GUID rather than throwing
        SessionId := SA.GetSessionId(Result);
        Assert.IsTrue(IsNullGuid(SessionId), 'Malformed sessionId must surface as a null GUID');
    end;

    var
        Assert: Codeunit "Library Assert";
}
