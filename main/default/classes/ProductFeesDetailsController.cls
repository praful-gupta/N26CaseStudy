/****************************************************************************************************
Class    :  ProductFeesDetailsController
Developer:  Praful
Created  :  Feburary 23, 2023
Objective:  This class provides methods for contactOnCaseProductFees LWC
ChangeHistory: 
****************************************************************************************************/

public with sharing class ProductFeesDetailsController {
    
   /*************************************************************
    Method   :  fetchClientFees
    Developer:  Praful
    Objective:  This method will fetch Product_Fees__c details from custom object based on contact associated to case
    *************************************************************/
  
    @AuraEnabled(cacheable=true)
    public static List<customProductFees> fetchClientFees(string caseId) {
        List<Product_Fees__c> clientrelatedProductFees = new    List<Product_Fees__c> ();
        // fetch contact on case Product__c and Home_Country__c
        List<Case> listCase = [SELECT Id, Contact.Product__c, Contact.Home_Country__c
                              FROM Case
                              WHERE Id = :caseId LIMIT 1];
        
        if(listCase.size() > 0){ 
            //based on contact on case Product__c and Home_Country__c get fees detail from Product_Fees__c custom object
            if(listCase[0].Contact.Product__c != null && listCase[0].Contact.Home_Country__c != null){

                List<customProductFees> clientrelatedProductFeesWrapper = new    List<customProductFees> ();

                
                clientrelatedProductFees = [SELECT id, Fees__c, CurrencyIsoCode, Home_Country__c, Cost_Type__c, Product_Type__c
                                            FROM Product_Fees__c
                                            WHERE Product_Type__c =: listCase[0].Contact.Product__c and Home_Country__c =: listCase[0].Contact.Home_Country__c ];
                
                
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
       return null;                         
    }
    
    public class customProductFees{
        
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