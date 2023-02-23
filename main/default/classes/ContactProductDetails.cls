/****************************************************************************************************
Class    :  ContactProductDetails
Developer:  Praful
Created  :  Feburary 23, 2023
Objective:  This class provides Apex REST Methods like HttpGet for external service to get Product Fees details and implement global class
ChangeHistory: 
****************************************************************************************************/
@RestResource(urlMapping = '/product-fees-management/contact/*')
global class ContactProductDetails {
    
    /*************************************************************
    Method   :  getProductFees
    Developer:  Praful
    Objective:  This method will accept UUID as paremeter in endpoint and get associated conatct and fees datails based on contact Product and home country  
    *************************************************************/
    
    @HttpGet
    global static list<customProductFees> getProductFees() 
    {
        RestRequest req = RestContext.request;
        String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        system.debug('xc' + contactId);
        if(contactId != null){        
            List<Product_Fees__c> clientrelatedProductFees = new    List<Product_Fees__c> ();
            // fetch contact's Product__c and Home_Country__c
            List<contact> listContact = [SELECT Id, Product__c, Home_Country__c
                                         FROM contact
                                         WHERE UUID__c = :contactId LIMIT 1];
            
            if(listContact.size() > 0){ 
                //based on contact Product__c and Home_Country__c get fees detail from Product_Fees__c custom object
                if(listContact[0].Product__c != null && listContact[0].Home_Country__c != null){
                    
                    List<customProductFees> clientrelatedProductFeesWrapper = new    List<customProductFees> (); 
                    clientrelatedProductFees = [SELECT id, Fees__c, CurrencyIsoCode, Home_Country__c, Cost_Type__c, Product_Type__c
                                                FROM Product_Fees__c
                                                WHERE Product_Type__c =: listContact[0].Product__c and Home_Country__c =: listContact[0].Home_Country__c ];
                    
                    
                    if(clientrelatedProductFees.size() > 0){                   
                        for (Product_Fees__c pf : clientrelatedProductFees){
                            if(!pf.Fees__c.isNumeric()){
                                clientrelatedProductFeesWrapper.add(new customProductFees(pf.Cost_Type__c, pf.Home_Country__c, pf.Fees__c, pf.Product_Type__c ));
                            } else{
                                String feesWithCurrency = pf.CurrencyIsoCode + ' ' + pf.Fees__c;
                                clientrelatedProductFeesWrapper.add(new customProductFees(pf.Cost_Type__c, pf.Home_Country__c, feesWithCurrency, pf.Product_Type__c ));
                            }
                        }
                    }  
                    return clientrelatedProductFeesWrapper;         
                }
            }
            
        }
        return null;      
    }
    
    global class customProductFees{
        
        @AuraEnabled public String costType;
        @AuraEnabled public String homeCountry;
        @AuraEnabled public String fees;
        @AuraEnabled public String productType;
        
        public customProductFees(string costType, string homeCountry, string fees, string productType ){
            this.costType = costType;
            this.homeCountry = homeCountry;
            this.fees = fees;
            this.productType = productType;
        }    
    }
    
}