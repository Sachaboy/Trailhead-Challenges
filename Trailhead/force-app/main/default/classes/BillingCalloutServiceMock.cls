@isTest
global class BillingCalloutServiceMock implements WebServiceMock {
    public static Boolean shouldFail = false;
    public static Boolean shouldThrowException = false;

    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseName,
        String responseNamespace,
        String clientNamespace
    ) {
        if (shouldThrowException) {
            throw new CalloutException('Simulated SOAP exception');
        }
        response.put('response_x', shouldFail ? 'error' : 'ok');
    }
}