({
	doInit: function(cmp, evt, helper) {
		var action = cmp.get("c.getCaseContactInfo");
        action.setParams({ caseId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var value = response.getReturnValue();
                cmp.set("v.product", value.contactInfo.Product__c);
                console.log('value',value);
                cmp.set("v.legalCountry", value.contactInfo.Home_Country__c);
                cmp.set("v.packageList", value.packageInfoList);
                cmp.set("v.contactName", value.contactInfo.Name);
                cmp.set("v.contactId", value.contactInfo.Id);
            }
        });
        $A.enqueueAction(action);
    },
    
    editProduct: function(cmp, evt, helper) {
        cmp.set("v.editProduct", true);
    },
    closeModel: function(component, event, helper) {
      component.set("v.editProduct", false);
   },
  
   submitDetails: function(component, event, helper) {
      component.find("editForm").submit();
      component.set("v.editProduct", false);
      $A.get('e.force:refreshView').fire();
      
   },
})