@isTest
private class RewardsCalloutServiceTest {

    @isTest
    static void testSuccessfulRewardCallout() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(false));
        String json = '{"userId": "001xx000003DGbY", "reward": "gold"}';

        Test.startTest();
        Integer code = RewardsCalloutService.submitUsersForRewardCallout(json);
        Test.stopTest();

        System.assertEquals(200, code, 'Expected successful status code.');
    }

    @isTest
    static void testFailedRewardCallout() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(true));
        String json = '{"userId": "001xx000003DGbY", "reward": "gold"}';

        Test.startTest();
        Integer code = RewardsCalloutService.submitUsersForRewardCallout(json);
        Test.stopTest();

        System.assertEquals(500, code, 'Expected failure status code.');
    }
    @isTest
    static void testCalloutThrowsException() {
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(false,true));

        Test.startTest();
        Integer status = RewardsCalloutService.submitUsersForRewardCallout('{"simulate": "exception"}');
        Test.stopTest();

        System.assertEquals(500, status, 'Expected fallback 500 status when exception is thrown');
    }
}