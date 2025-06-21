@isTest
private class BillingCalloutServiceTest {

    static Accessibility_Project__c setupTestProject(String status) {
        Accessibility_Project__c proj = new Accessibility_Project__c(
            Status__c = status
        );
        insert proj;
        return proj;
    }

    @isTest
    static void testSuccessfulBilling() {
        BillingCalloutServiceMock.shouldFail = false;
        BillingCalloutServiceMock.shouldThrowException = false;

        Accessibility_Project__c proj = setupTestProject('Submitted');

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

        Test.startTest();
        AccessibilityProjectBilling.callBillingService(proj.Id, 100.00);
        Test.stopTest();

        Accessibility_Project__c updated = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :proj.Id];
        System.assertEquals('Complete', updated.Status__c, 'Status should be updated to Complete on successful billing call');
    }

    @isTest
    static void testFailedBillingResponse() {
        BillingCalloutServiceMock.shouldFail = true;
        BillingCalloutServiceMock.shouldThrowException = false;

        Accessibility_Project__c proj = setupTestProject('Submitted');

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

        Test.startTest();
        AccessibilityProjectBilling.callBillingService(proj.Id, 100.00);
        Test.stopTest();

        Accessibility_Project__c updated = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :proj.Id];
        System.assertEquals('Submitted', updated.Status__c, 'Status should remain Submitted when billing response is error');
    }

    @isTest
    static void testBillingSoapException() {
        BillingCalloutServiceMock.shouldThrowException = true;

        Accessibility_Project__c proj = setupTestProject('Submitted');

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

        Test.startTest();
        AccessibilityProjectBilling.callBillingService(proj.Id, 100.00);
        Test.stopTest();

        Accessibility_Project__c updated = [SELECT Status__c FROM Accessibility_Project__c WHERE Id = :proj.Id];
        System.assertEquals('Submitted', updated.Status__c, 'Status should remain Submitted when SOAP exception occurs');
    }
}