global class AccessibilityProjectBilling{
   
   @future(callout = true)
   public static void callBillingService(String projectId, Decimal billingAmount){
       BillingServiceProxy.InvoicesPortSoap11 stub = new BillingServiceProxy.InvoicesPortSoap11();

       //Setup username, password, billAmount, and projectid in BillingServiceProxy.project and then call billProject method
       BillingServiceProxy.project project = new BillingServiceProxy.project();
       project.projectid = projectid;
       project.billAmount = Double.valueof(billingAmount);
       project.username = '{!$Credential.BillingServiceCredential.username}';
       project.password = '{!$Credential.BillingServiceCredential.password}';
       

         //If response is ok set Accessibility Project Status = Complete
       try{
           string status = stub.billProject(project);
           if(status == 'ok'){
               Accessibility_Project__c accproject = [Select Id, Status__c from Accessibility_Project__c where Id =: projectId limit 1 ];
               accproject.Status__c = 'Complete';
               update accproject;
           }
           
       }catch(exception e){
           System.debug('Soap Call failed' + e.getMessage());
           
       }
            
    }
}