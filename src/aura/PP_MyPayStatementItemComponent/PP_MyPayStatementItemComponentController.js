({
    doInit: function(component, event, helper) {
     /*   var name = component.get("v.fieldName");
        
        component.set("v.isOpenSummaryPage",false);
        var toggleText = component.find("myButton");
        $A.util.addClass(toggleText, 'invisible');
        var selYear = component.get("v.selectedYear");
        var action = component.get("c.lstPay1");
        console.log('strSelectedYear==='+selYear);
        console.log('name==='+name);
        action.setParams({
            "strSelectedYear" : JSON.stringify(selYear),
             "strName": name
        });
        action.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                console.log('component==='+response.getReturnValue());
                component.set("v.wraperlst",response.getReturnValue());
                var changeColor = component.get("v.payLst");
            }
        });
         $A.enqueueAction(action);   */       
    },
    changeColor : function(component, event, helper) {
		var changeBackground = component.find('trId');
        $A.util.addClass(changeBackground, "red-cell");
	},
    openPdf : function(component, event, helper) {
       // console.log("jQuery('div.pay-summary-page')"+jQuery("div.pay-summary-page"));
        //jQuery("div.pay-summary-page").scrollTop(0);
        //jQuery('div.pay-summary-page').offset({ top: 0});
       //if(typeof(jQuery) != "undefined"){
          
        var cssScrolltoTop = jQuery(".scroller"); // css class to find scroll position
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
      // }
       // window.scrollTop(0);
        var selectedItem = event.currentTarget;
        //console.log('selectedItem==='+selectedItem);   
       // var Name = selectedItem.dataset.record;
       // component.set("v.selectedId",Name);
        //$A.util.addClass(selectedItem,"ctsSelected");
        var monthName = selectedItem.dataset.name;
        
        var NetPay = selectedItem.dataset.netpay;
         
        var CURwages = selectedItem.dataset.curwages;
        var YTDwages = selectedItem.dataset.ytdwages;
        var CURdeduction = selectedItem.dataset.curdeduction;
        var YTDdeduction = selectedItem.dataset.ytddeduction;
        var CURtax = selectedItem.dataset.curtax;
        var YTDtax = selectedItem.dataset.ytdtax;
        var directDeposit = selectedItem.dataset.directdeposit;
        var YTDDirectDep = selectedItem.dataset.ytddirectdep;
        var CURDirectDep = selectedItem.dataset.curdirectdep;
        var date = selectedItem.dataset.date;
        var isCheck = selectedItem.dataset.check;
        var cheque = selectedItem.dataset.cheque;
        var SequenceNumber = selectedItem.dataset.sequencenumber;
        
        component.set("v.NetPay",NetPay);
        component.set("v.CURwages",CURwages);
        component.set("v.YTDwages",YTDwages);
        component.set("v.CURdeduction",CURdeduction);
        component.set("v.YTDdeduction",YTDdeduction);
        component.set("v.CURtax",CURtax);
        component.set("v.YTDtax",YTDtax);
        component.set("v.directDeposit",directDeposit);
        component.set("v.YTDDirectDep",YTDDirectDep);
        component.set("v.CURDirectDep",CURDirectDep);
        component.set("v.date",date);
        component.set("v.isCheck",isCheck);
        component.set("v.cheque",cheque);
        component.set("v.SequenceNumber",SequenceNumber);
      /*  $A.createComponent(
            "c:PP_MyPayStatementSummaryComponentCopy",
            {
            },
            function(newCmp){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newCmp);
                    component.set("v.body", body);
                }
            }
            alert(component.get("v.body"));
        ); */
       // $A.get("e.c:PP_MyPayStatementListMethodEvent").setParams({term: monthName}).fire();
        var myEvent = $A.get("e.c:PP_MyPayStatementMasterMethodEvent");
        myEvent.fire();
        component.set("v.isOpenDetails",false);
        component.set("v.isOpenSummaryPage",true);
        
    },
    
    gotSummaryEvent : function(component, event, helper) {
        //alert();
        //component.set("v.isOpenDetails",true);
        if(component.get("v.isOpenSummaryPage") != undefined){
            component.set("v.isOpenSummaryPage",false);
        }
        if(component.get("v.isCheckRender") != undefined){
            component.set("v.isCheckRender",true);
        }
    }
})