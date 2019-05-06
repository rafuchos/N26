@isTest
public class N26DailyEmailSendTest {
	@testSetup
    public static void createData(){
        Contact testContact = new Contact();
        testContact.FirstName = 'Maria';
        testContact.LastName = 'da Gloria de jesus';
        testContact.survey_date__c = system.today().addDays(-1);
        testContact.Email = 'mariaEmail@test.com';
        testContact.language__c = 'en';
        insert testContact;
        
        Contact secondContact = new Contact();
        secondContact.FirstName = 'João';
        secondContact.LastName = 'José';
        secondContact.survey_date__c = system.today().addDays(-1);
        secondContact.Email = 'joaojose@test.com';
        secondContact.language__c = 'de';
        insert secondContact;
        
        N26__c n26Setting = new N26__c();
        n26Setting.ApiEndpoint__c = 'test';
        insert n26Setting;
    }
    
    @isTest
    public static void testSchedule(){
        Test.setMock(HttpCalloutMock.class, new N26SalesforceLimitsMock());
        test.startTest();
        N26DailyEmailSendScheduler.scheduleDaily('Crazy Name for scheduled apex');
        test.stopTest();

    }
    
    @isTest
    public static void testBatchable(){
        Test.setMock(HttpCalloutMock.class, new N26SalesforceLimitsMock());
        //check contact to make sure date is before today
        Contact testContactBefore = [SELECT id,survey_date__c FROM Contact WHERE Email = 'mariaEmail@test.com'];
        system.assertEquals(system.today().addDays(-1), testContactBefore.survey_date__c);
        Contact secondContactBefore = [SELECT survey_date__c FROM Contact WHERE Email = 'joaojose@test.com'];
        system.assertEquals(system.today().addDays(-1), secondContactBefore.survey_date__c);
        test.startTest();
        N26DailyEmailSend emailBatch = new N26DailyEmailSend(); 
        database.executeBatch(emailBatch);
        test.stopTest();
        //check contact has update survey date after batch has run
        Contact testContact = [SELECT id,survey_date__c FROM Contact WHERE Email = 'mariaEmail@test.com'];
        system.assertEquals(null, testContact.survey_date__c);
        Contact secondContact = [SELECT survey_date__c FROM Contact WHERE Email = 'joaojose@test.com'];
        system.assertEquals(null, secondContact.survey_date__c);
    }
}