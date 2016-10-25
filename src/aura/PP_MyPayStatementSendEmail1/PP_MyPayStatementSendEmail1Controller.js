({
	hideEmailCmp : function(component, event, helper) {
        var cmpName = component.get("v.ComponentName");
		var myEvent = $A.get("e.c:PP_MyPayStatementSendEmail1Evt").setParams({checkComponent: cmpName});
        myEvent.fire();
        
	},
    doInit : function(component, event, helper) {
        component.set("v.openEmail",true);
        var action = component.get("c.strEmailAddress");
        action.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                var getEmail = response.getReturnValue();
                if(getEmail != '' || getEmail != undefined){
                    if(getEmail.indexOf('@')){
                        var changedEmailAddress = getEmail.split('@');
                        var nameOfEmployee = changedEmailAddress[0];
                        var companyOfEmployee = '@'+changedEmailAddress[1];
                        if(nameOfEmployee != '' || nameOfEmployee != undefined ||  nameOfEmployee != NULL){
                            component.find("employeeName").set("v.value",nameOfEmployee) 
                        }
                        if(companyOfEmployee != '' || companyOfEmployee != undefined ||  companyOfEmployee != NULL){
                            component.find("employeeCompany").set("v.value",companyOfEmployee) 
                        }
                    }
                }
            }
        });
        $A.enqueueAction(action); 
    },
    sendEmail : function(component, event, helper) {
        var action = component.get("c.invokePayStubAPI_sendEmail");
        var date = component.get("v.date");
        var email = component.get("v.originalMailName") + component.get("v.originalMailEmployee");
        var SequenceNumber = component.get("v.SequenceNumber");
        action.setParams({
            "Paydate" : date,
             "SeqNumber": SequenceNumber,
            "EmailAddress": email
        });
        action.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
               	component.set("v.openEmail",false);
        		component.set("v.changeEmail",false);
                component.set("v.successMessage",true);
                component.set("v.failureMessage",false);
            }
            else{
                component.set("v.openEmail",false);
        		component.set("v.changeEmail",false);
                component.set("v.successMessage",false);
                component.set("v.failureMessage",true);
            }
        });
         $A.enqueueAction(action); 
    },
    changeEmailAddress : function(component, event, helper) {
       /* var re = '/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z.-]{2,}))$/';
        var text = component.find("changedEmailAddress");
        if(text != undefined)
         var text1 = text.get("v.value");
        console.log('==text==='+text1);
        var x = re.test(text1);
        alert(x);*/
       // document.getElementById("demo").innerHTML = re.test(text1);
        component.set("v.openEmail",false);
        component.set("v.changeEmail",true);
    },
    hideChangeEmail: function(component, event, helper) {
        component.set("v.openEmail",true);
        component.set("v.changeEmail",false);
    },
    conformMail : function(component, event, helper) {
        var changedEmailVal = component.find("changedEmailAddress").get("v.value"); 
       // var emailReg = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
        var emailReg = new RegExp("^([0-9a-zA-Z]([-.\\w\\+]*[0-9a-zA-Z\\+])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$");
      //  var emailReg = new RegExp([a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?);
         
        var valid = emailReg.test(changedEmailVal);
        if(valid){    
            
        component.set("v.openEmail",true);
        component.set("v.changeEmail",false);             
            
            if(changedEmailVal != undefined ){
                if(changedEmailVal.indexOf('@')){
                    var changedEmailAddress = changedEmailVal.split('@');
                    var nameOfEmployee = changedEmailAddress[0];
                    if(changedEmailAddress[1] != undefined){
                        var companyOfEmployee = '@'+changedEmailAddress[1];
                        if(nameOfEmployee != '' || nameOfEmployee != undefined ||  nameOfEmployee != NULL){
                            component.find("employeeName").set("v.value",nameOfEmployee) 
                        }
                        if(companyOfEmployee != '' || companyOfEmployee != undefined ||  companyOfEmployee != NULL){
                            component.find("employeeCompany").set("v.value",companyOfEmployee) 
                        }
                    }
                    else{
                        var changedEmailAddress = changedEmailVal.split('@');
                        var nameOfEmployee = changedEmailAddress[0];
                        var companyOfEmployee = null;
                        component.find("employeeName").set("v.value",nameOfEmployee)
                        component.find("employeeCompany").set("v.value",companyOfEmployee) 
                    }
                }
            }
            else{
                var changedEmailAddress = null;
                var nameOfEmployee = null;
                var companyOfEmployee = null;
                component.find("employeeName").set("v.value",nameOfEmployee)
                component.find("employeeCompany").set("v.value",companyOfEmployee) 
            }   
            document.getElementById("errorMsg").style.display="none";
        } 
        else
        {  
            document.getElementById("errorMsg").style.display="block";    
            component.find("changedEmailAddress").set("v.value",changedEmailVal);
            return false;
        }        
    },
    openMasterComponent :function(component, event, helper){
        component.set("v.openEmail",false);
        component.set("v.changeEmail",false);
        component.set("v.successMessage",false);
        component.set("v.failureMessage",false);
        var myEvent = $A.get("e.c:PP_OpenMyPayStatementMasterComponent");
        myEvent.fire();
    },
    tryAgain:function(component, event, helper){
        component.set("v.openEmail",false);
        component.set("v.changeEmail",true);
        component.set("v.successMessage",false);
        component.set("v.failureMessage",false);
        component.set("v.isOpenMasterComponent",false);
    }
})