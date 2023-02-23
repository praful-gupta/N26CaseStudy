@isTest
private  class ProductFeesDetailsController_Test {
    
    @testsetup
    static void testDataCreation(){
        
        Account acc = new Account();
        acc.name = 'test acc';
        acc.BillingCity = 'test city';
        acc.billingState = 'test state';
        insert acc;
        
        Contact cont = new Contact();
        cont.FirstName = 'test';
        cont.LastName = 'cont';
        cont.Email = 'testEmail@testPg.com';
        cont.AccountId = acc.Id;
        cont.Product__c = 'Standard';
        cont.Home_Country__c = 'DE';
        insert cont;
        
        Case cs = new Case();
        cs.subject = 'test subject';
		cs.Description = 'test description';
        cs.ContactId = cont.id;
        cs.Status = 'New';
		cs.Origin = 'Email';
        insert cs;
        
        Product_Fees__c pfee = new Product_Fees__c();
        pfee.name = 'test rec';
        pfee.Cost_Type__c = 'Cost per Calendar Month';
        pfee.Home_Country__c = 'DE';
        pfee.Fees__c =  '10';
        pfee.Product_Type__c = 'Standard';
        insert pfee;

        Product_Fees__c pfee1 = new Product_Fees__c();
        pfee1.name = 'test rec2';
        pfee1.Cost_Type__c = 'Cost per Calendar Month';
        pfee1.Home_Country__c = 'DE';
        pfee1.Fees__c =  '10';
        pfee1.Product_Type__c = 'Metal';
        insert pfee1;

        Product_Fees__c pfee2 = new Product_Fees__c();
        pfee2.name = 'test rec2';
        pfee2.Cost_Type__c = 'Cost per Calendar Month';
        pfee2.Home_Country__c = 'DE';
        pfee2.Fees__c =  '10';
        pfee2.Product_Type__c = 'Black';
        insert pfee2;
        
    }   
    
    @isTest
    static void testfetchClientFees(){
        
        List<Case> caseList = [select id from case limit 1];
        List<ProductFeesDetailsController.customProductFees> feewrapper = ProductFeesDetailsController.fetchClientFees(caseList[0].id);
        System.assert(feewrapper != null,'');
        System.assertEquals(feewrapper[0].fees, 'EUR 10','test');
        
    }
    
}