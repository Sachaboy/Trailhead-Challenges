@isTest
private class WellnessJourneyRewardsBatchTest {

    static User createTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        return new User(
            Username = 'testuser@example.com',
            Alias = 'tuser',
            Email = 'test@example.com',
            LastName = 'Test',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'Africa/Johannesburg',
            ProfileId = p.Id
        );
    }

    static Date getPreviousQuarterStartDate() {
        Date today = Date.today();
        Integer currentMonth = today.month();
        Integer startMonth = ((currentMonth - 1) / 3) * 3 + 1 - 3;
        Integer year = today.year();
        if (startMonth <= 0) {
            startMonth += 12;
            year--;
        }
        return Date.newInstance(year, startMonth, 1);
    }

    static void createTestJourneys(Id ownerId, Date startDate) {
        List<Wellness_Journey__c> records = new List<Wellness_Journey__c>();
        for (Integer i = 0; i < 12; i++) {
            records.add(new Wellness_Journey__c(
                Name = 'Journey ' + i,
                OwnerId = ownerId,
                Status__c = 'Complete',
                Completion_Date__c = startDate.addDays(i)
            ));
        }
        insert records;
    }

    @isTest
    static void testBatchSuccessPath() {
        User u = createTestUser();
        insert u;

        Date quarterStart = getPreviousQuarterStartDate();
        createTestJourneys(u.Id, quarterStart);

        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(false));

        Test.startTest();
        Database.executeBatch(new WellnessJourneyRewardsBatch(), 5);
        Test.stopTest();
    }

    @isTest
    static void testBatchFailurePath() {
        User u = createTestUser();
        insert u;

        Date quarterStart = getPreviousQuarterStartDate();
        createTestJourneys(u.Id, quarterStart);

        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock(true));

        Test.startTest();
        Database.executeBatch(new WellnessJourneyRewardsBatch(), 5);
        Test.stopTest();
    }
}