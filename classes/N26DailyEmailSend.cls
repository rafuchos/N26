global class N26DailyEmailSend implements Database.Batchable<sObject>,Database.AllowsCallouts {
	global Database.QueryLocator start(Database.BatchableContext BC) {       
        String query = 'SELECT Id,Name, Language__c, FirstName, Email FROM Contact WHERE survey_date__c < today';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
        //check max single email left in Salesforce API
        Integer emailCount = getSingleEmailCount();
        Integer countLoop = 1;
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Messaging.SingleEmailMessage> allEmails = new List<Messaging.SingleEmailMessage>();
        for(Contact contactInfo : contactList){
            EmailTemplate template = new EmailTemplate();
            if(contactInfo.Language__c == 'EN'){
                template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'N26_Daily_En'];
            }else if(contactInfo.Language__c == 'DE'){
                template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'N26_Daily_De'];
            }
            List<string> toAddress = new List<string>();
			toAddress.add(contactInfo.Email);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(template.Id);
            mail.setToAddresses(toAddress);
            mail.setTargetObjectId(contactInfo.id);   
            
            if(countLoop <= emailCount){
                allEmails.add(mail);
                Contact updateContact = contactInfo;
                updateContact.survey_date__c = null;
                contactsToUpdate.add(updateContact);
            }
         
        }
        try {        
            update contactsToUpdate;
            Messaging.SendEmailResult[] results = Messaging.sendEmail(allEmails,false);         
            system.debug('test'+contactsToUpdate);
            return;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
		
   }
    
    public static Integer getSingleEmailCount(){
        Integer singleEmailLimit;
        String endpoint = [SELECT ApiEndpoint__c FROM N26__c].ApiEndpoint__c;
        HttpRequest req = new HttpRequest();                            
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'OAuth '+ UserInfo.getSessionId());
        Http http = new Http();               
        HTTPResponse res = http.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        if ( res.getStatusCode() == 200 ) {
            N26SalesforceLimits limits = N26SalesforceLimits.parse(res.getBody());
            singleEmailLimit =  limits.SingleEmail.Remaining;
        }
        return singleEmailLimit;
    }
}