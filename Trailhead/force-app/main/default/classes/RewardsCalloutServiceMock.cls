// Existing class
@isTest
global class RewardsCalloutServiceMock implements HttpCalloutMock {
    public Boolean shouldFail { get; set; }
    public Boolean shouldThrowException { get; set; }

    // Existing 2-arg constructor
    global RewardsCalloutServiceMock(Boolean shouldFail, Boolean shouldThrowException) {
        this.shouldFail = shouldFail;
        this.shouldThrowException = shouldThrowException;
    }

    // NEW: Overload for legacy tests that pass only one argument
    global RewardsCalloutServiceMock(Boolean shouldFail) {
        this.shouldFail = shouldFail;
        this.shouldThrowException = false;
    }

    global HTTPResponse respond(HTTPRequest req) {
        if (shouldThrowException) {
            throw new CalloutException('Simulated callout exception');
        }

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        if (shouldFail) {
            res.setStatusCode(500);
            res.setBody('{"error": "Internal Server Error"}');
        } else {
            res.setStatusCode(200);
            res.setBody('{"message": "Reward successfully submitted"}');
        }

        return res;
    }
}