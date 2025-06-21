@isTest
private class ProductZoningServiceTest {
    @isTest
    static void testPermissibleFlyZone() {
        Product2 product = new Product2(ProductCode = 'AMER_Fixed_Wing', Family = 'Fixed-Wing', Name = 'Test Product');
        insert product;
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.params.put('ProductCode', product.ProductCode);
        req.headers.put('CountryCode', 'US');
        RestContext.request = req;
        String result = ProductZoningService.getFlyZone();
        Test.stopTest();
        
        System.assertEquals('Regulated', result);
    }
    
    @isTest
    static void testConfirmWithAuthorities() {
        Product2 product = new Product2(ProductCode = 'AMER_Fixed_Wing', Family = 'UnknownFamily', Name = 'Test Product 2');
        insert product;
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.params.put('ProductCode', product.ProductCode);
        req.headers.put('CountryCode', 'US');
        RestContext.request = req;
        String result = ProductZoningService.getFlyZone();
        Test.stopTest();
        
        System.assertEquals('Confirm with the local authorities', result);
    }
    
    @isTest
    static void testInvalidProductCode() {
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.params.put('ProductCode', '');
        req.headers.put('CountryCode', 'US');
        RestContext.request = req;
        String result = ProductZoningService.getFlyZone();
        Test.stopTest();
        
        System.assertEquals('ProductCode is missing or doesn\'t exist', result);
    }
    
    @isTest
    static void testDefaultCountryCode() {
        Product2 product = new Product2(ProductCode = 'AMER_Fixed_Wing', Family = 'Fixed-Wing', Name = 'Test Product 3');
        insert product;
        
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductZoning/';
        req.params.put('ProductCode', product.ProductCode);
        RestContext.request = req;
        String result = ProductZoningService.getFlyZone();
        Test.stopTest();
        
        System.assertEquals('Regulated', result);
    }
}