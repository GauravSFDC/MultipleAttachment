({
    doInit : function(component, event, helper) {
        component.set("v.hideDetails",true);
        var payValue = component.get("v.selectedYear");
        alert('==payNewVal11='+payValue);
        if(payValue === undefined){
            var action1 = component.get("c.intCurrentYear");
            action1.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === 'SUCCESS'){
                    component.set("v.selectedYear",response.getReturnValue());
                    var payNewVal = component.get("v.selectedYear");
                    var action = component.get("c.lstPay");
                    console.log('==payNewVal='+payNewVal);
                    action.setParams({
                        "strSelectedYear" : JSON.stringify(payNewVal)
                    });
                    
                    action.setCallback(this,function(response){
                        var state = response.getState();
                        if(component.isValid() && state === 'SUCCESS'){
                            console.log('==response.getReturnValue()=123=='+response.getReturnValue())
                            if(response.getReturnValue() == '' || response.getReturnValue() == undefined){
                                var myEvent = $A.get("e.c:PP_MyPayStatementErrorMessage");
                                console.log('==response.getReturnValue()11==='+response.getReturnValue())
                                myEvent.fire();
                            }
                            component.set("v.payStmtList",response.getReturnValue());
                        }
                        else {
                            console.log("Failed with state: " + state);
                        }
                    });	
                    $A.enqueueAction(action);
                }
                else {
                    console.log("Failed with state: " + state);
                }
            }); 
            $A.enqueueAction(action1);
        }
        else{
            var action = component.get("c.lstPay");
            action.setParams({
                "strSelectedYear" : JSON.stringify(payValue)
            });
            
            action.setCallback(this,function(response){
                var state = response.getState();
                if(component.isValid() && state === 'SUCCESS'){
                    console.log('==response.getReturnValue()12==='+response.getReturnValue())
                    if(response.getReturnValue() == '' || response.getReturnValue() == undefined){
                        var myEvent = $A.get("e.c:PP_MyPayStatementErrorMessage");
                        console.log('==response.getReturnValue()11==='+response.getReturnValue())
                        myEvent.fire();
                    }
                    component.set("v.payStmtList",response.getReturnValue());
                }
                else {
                    console.log("Failed with state: " + state);
                }
            });	
            $A.enqueueAction(action);
        }
    },
    changeFunction : function(component, event, helper){
         var arr = [];
        arr = component.find("tableId").getElement().childNodes;
        for(var cmp in component.find("tableId").getElement().childNodes) {
            $A.util.removeClass(arr[cmp], "ctsHeader");
            $A.util.removeClass(arr[cmp], "ctsSelected");
        }
        var targetElement = event.currentTarget;
        $A.util.addClass(targetElement,"ctsHeader");
    },
    gotEvent: function(component, event, helper) {
        var searchedMonthName=event.getParam("term");
      /*  component.set('v.msg',
                      'You searched for the term [' + searchedTerm +
                      '] - if I had an Apex controller, ' +
                      ' I might find some matching records');selectedItem.dataset.name;*/
        console.log('event terget '+searchedMonthName);
        var arr = [];
        arr = component.find("tableIdMain").getElement().childNodes;
        console.log('check render '+component.find("tableIdMain").getElement().childNodes );
        for(var cmp in component.find("tableIdMain").getElement().childNodes) {
            $A.util.addClass(arr[cmp], "invisible");
            if(arr[cmp].dataset !== undefined){
                if(arr[cmp].dataset.name == searchedMonthName ){
                    $A.util.removeClass(arr[cmp], "invisible");
                }
            }             
        }
    },
    gotSummaryEvent : function(component, event, helper) {
        var arr = [];
        arr = component.find("tableIdMain").getElement().childNodes;
        for(var cmp in component.find("tableIdMain").getElement().childNodes) {
           // console.log('check render is working');
            $A.util.removeClass(arr[cmp], "invisible");
        }
    },
})