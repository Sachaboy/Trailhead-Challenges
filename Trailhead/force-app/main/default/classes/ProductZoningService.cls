@RestResource(urlMapping='/ProductZoning/*')
global class ProductZoningService {
    @HttpGet
    global static String getFlyZone() {
                RestRequest req = RestContext.request;
        system.debug('req=> '+ req);
        Map<String, String> queryParams = req.params;
        String productCode = queryParams.get('ProductCode');
        
        system.debug('Request URI: ' + req.requestURI);        
        String countryCode = req.headers.get('CountryCode');
        
        if (countryCode == null) {
            countryCode = 'US'; // Use 'US' as the default country code
        }
        
        system.debug('ProductCode: '+ productCode);
        system.debug('CountryCode: '+ countryCode);
        
        if (String.isBlank(productCode)) {
            return 'ProductCode is missing or doesn\'t exist';
        }
        
        List<Product2> products = [SELECT Id, Family FROM Product2 WHERE ProductCode = :productCode LIMIT 1];
        if (products.isEmpty()) {
            return 'ProductCode is missing or doesn\'t exist';
        }
        
        String productFamily = products[0].Family;
        
        system.debug('ProductFamily: '+ productFamily);
        
        List<Product_Geo_Mapping__mdt> mappings = [
            SELECT Permissible_Fly_Zone__c 
            FROM Product_Geo_Mapping__mdt 
            WHERE Product_Family__c = :productFamily 
            AND Country_Code__c = :countryCode 
            LIMIT 1
        ];
        
        if (!mappings.isEmpty()) {
            system.debug('mappings[0].Permissible_Fly_Zone__c => '+ mappings[0].Permissible_Fly_Zone__c);
            return mappings[0].Permissible_Fly_Zone__c;
        } else {
            return 'Confirm with the local authorities';
        }
    }
}