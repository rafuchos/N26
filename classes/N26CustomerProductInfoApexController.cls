public class N26CustomerProductInfoApexController {
    @AuraEnabled
    public static ProductInformationWrapper getCaseContactInfo(String caseId){
        String contactId = [SELECT ContactId FROM Case WHERE Id =: caseId].ContactId;
        Contact caseContact = [SELECT Id, Name, Product__c, Home_Country__c FROM Contact WHERE Id =: contactId ];
        
        List<Product__c> productList = [SELECT id, Country__c, Package__c, Type__c, Cost__c, Fee__c
                          	FROM Product__c
                          	WHERE Country__c = : caseContact.Home_Country__c 
                            AND Type__c = : caseContact.Product__c];
        
        List<PackageInfoWrapper> packageInfoList = new List<PackageInfoWrapper>();
        for(Product__c productInfo : productList){
            String price;
            if(productInfo.Fee__c == false){
                price = '€ ' + productInfo.Cost__c;
            }else {
                if(productInfo.Cost__c != 0){
                    price = 'Free';
                }
                else{
                    price = productInfo.Cost__c + '%';
                }
            }
            PackageInfoWrapper packageInfo = new PackageInfoWrapper(productInfo.Package__c, price);
            packageInfoList.add(packageInfo);
        }
        
        ProductInformationWrapper productInfoWrapper = new ProductInformationWrapper(caseContact, packageInfoList);
        return productInfoWrapper;
    }


    public class ProductInformationWrapper{
        @AuraEnabled
        public Contact contactInfo {get;set;}
        @AuraEnabled
        public List<PackageInfoWrapper> packageInfoList{get;set;}
            
        public ProductInformationWrapper (Contact contactInfo, List<PackageInfoWrapper> packageInfoList){
            this.contactInfo = contactInfo;
            this.packageInfoList = packageInfoList;
        }
    }
    
    public class PackageInfoWrapper {
        @AuraEnabled
        public String packageName  {get;set;}
        @AuraEnabled
        public String packagePrice {get;set;}
            
        public PackageInfoWrapper (String packageName, String packagePrice){
            this.packageName = packageName;   
            this.packagePrice = packagePrice; 
        }
    }
}