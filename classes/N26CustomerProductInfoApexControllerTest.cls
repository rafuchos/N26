@isTest
public class N26CustomerProductInfoApexControllerTest {
	@testSetup
    public static void createData(){
        Contact testContact = new Contact();
        testContact.FirstName = 'Maria';
        testContact.LastName = 'da Gloria de jesus';
        testContact.Product__c = 'Standard';
        testContact.Home_Country__c = 'DE';
        testContact.language__c = 'en';
        insert testContact; 
        
        Product__c costPerCalendar = new Product__c();
        costPerCalendar.Country__c = 'DE';
        costPerCalendar.Package__c = 'Cost per Calendar Month';
        costPerCalendar.Type__c = 'Standard';
        costPerCalendar.Cost__c = 0;
        insert costPerCalendar;
        
        Product__c cardReplacement = new Product__c();
        cardReplacement.Country__c = 'DE';
        cardReplacement.Package__c = 'Card Replacement Cost';
        cardReplacement.Type__c = 'Standard';
        cardReplacement.Cost__c = 6;
        insert cardReplacement;
        
        Case caseTest = new Case();
        caseTest.Origin = 'Web';
        caseTest.ContactId = testContact.Id;
        caseTest.Subject = 'Test Case';
        insert caseTest;
    }
    
    @isTest
    public static void getCaseContactInfoTest(){
        String caseId = [SELECT Id FROM Case LIMIT 1].Id;
        N26CustomerProductInfoApexController.ProductInformationWrapper allInfo = N26CustomerProductInfoApexController.getCaseContactInfo(caseId);
        system.assertEquals('Maria da Gloria de jesus', allInfo.contactInfo.Name);
        system.assertEquals('DE', allInfo.contactInfo.Home_Country__c);
        system.assertEquals('Standard', allInfo.contactInfo.Product__c);
    }
}