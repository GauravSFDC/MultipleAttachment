({
    doInit : function(component, event, helper) {
        component.set("v.hideDetails",true);
        var payValue = component.get("v.selectedYear");
        if(payValue === undefined){
            var action1 = component.get("c.getCurrentYear");
            action1.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === 'SUCCESS'){
                    component.set("v.selectedYear",response.getReturnValue());
                    var payNewVal = component.get("v.selectedYear");
                    var actions = component.get("c.lstPay");
                    actions.setParams({
                        "strSelectedYear" : JSON.stringify(payNewVal)
                    });
                    
                    actions.setCallback(this,function(response){
                        var state = response.getState();
                        if(component.isValid() && state === 'SUCCESS'){
                            if(response.getReturnValue() == '' || response.getReturnValue() == undefined){
                                var myEvent = $A.get("e.c:PP_MyPayStatementErrorMessage");
                                myEvent.fire();
                            }
                            component.set("v.payStmtList",response.getReturnValue()); 
                        }
                        else {
                            console.log("Failed with state: " + state);
                            var myEvent = $A.get("e.c:PP_MyPayStatementErrorMessage");
                            myEvent.fire();
                        }
                    });	
                    actions.setStorable();
                    $A.enqueueAction(actions);
                }
                else {
                    console.log("Failed with state: " + state);
                }
            }); 
            $A.enqueueAction(action1);
        }
        else{
            var actions = component.get("c.lstPay");
            actions.setParams({
                "strSelectedYear" : JSON.stringify(payValue)
            });
            
            actions.setCallback(this,function(response){
                var state = response.getState();
                if(component.isValid() && state === 'SUCCESS'){
                    if(response.getReturnValue() == '' || response.getReturnValue() == undefined){
                        var myEvent = $A.get("e.c:PP_MyPayStatementErrorMessage");
                        myEvent.fire();
                    }
                    component.set("v.payStmtList",response.getReturnValue());
                }
                else {
                    console.log("Failed with state: " + state);
                    var myEvent = $A.get("e.c:PP_MyPayStatementErrorMessage");
                                myEvent.fire();
                }
            });
            actions.setStorable();
            $A.enqueueAction(actions);
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
    },
    gotSummaryEvent : function(component, event, helper) {
        var arr = [];
    },
    
})