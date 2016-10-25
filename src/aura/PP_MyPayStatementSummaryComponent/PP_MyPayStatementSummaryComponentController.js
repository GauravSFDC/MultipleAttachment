({
	doInit : function(component, event, helper) {
        component.set("v.hideSummary",true);
        component.set("v.isEmail",false);
        var date1= component.get("v.date");
        var SequenceNumber1 = component.get("v.SequenceNumber");
        component.set("v.date2",date1);
        component.set("v.SequenceNumber2",SequenceNumber1);
	},
    hideSummary : function(component, event, helper) {
        document.getElementById('contextual-menu-container').style.width = "0em";
        var myEvent = $A.get("e.c:PP_MyPayStatementSummaryEvent1");
        myEvent.fire();
        component.set("v.hideSummary",false);
    },
    loadContext : function(component, event, helper) {
        jQuery(document).ready(function() {	
	/* Click functionality */
	jQuery('#contextual-menu-container').click(function(){
		jQuery(this).animate({'width': '20em'},300);
	});
	/* End click functionality */
	
	/* Touch functionality */
	jQuery('.current-pay-box').on('swiperight',function(){
		$('#contextual-menu-container').animate({'width': '1em'},300);
	});
	jQuery('.current-pay-box').on('swipeleft',function(){
		jQuery('#contextual-menu-container').animate({'width': '20em'},300);
	});
});


    },
    sendMail : function(component, event, helper) {
        if(component.get("v.isEmail") != undefined){
            component.set("v.isEmail",true);
            console.log('=====isEmail==');
        }            
        component.set("v.isEmail",true);
        var selectedItem = event.currentTarget;
        var SequenceNumber = selectedItem.dataset.sequncenumber;
        var date = selectedItem.dataset.date;
       // console.log('==SequenceNumber2==='+v.isEmail);
        component.set("v.SequenceNumber2",SequenceNumber);
        component.set("v.date2",date);
        component.set("v.isEmail",true);
        component.set("v.hideSummary",false);
        component.set("v.isFAQ",false);
        
    },
    hideEmailDetails : function(component, event, helper) {
        component.set("v.hideSummary",true);
        
        //component.set("v.isEmail",true);
        component.set("v.isEmail",false);
        component.set("v.isFAQ",false);
    },
    showContextualMenu : function(component, event, helper){
        var elementWidth = event.currentTarget;
        document.getElementById('contextual-menu-container').style.width = "23em";
    },
    hideContextualMenu : function(component, event, helper){
        document.getElementById('contextual-menu-container').style.width = "0em";
    },
    openFAQ : function(component, event, helper){
        var cssScrolltoTop = $(".scroller"); // css class to find scroll position
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
        
        var selectedItem = event.currentTarget;
        var selectedType = selectedItem.dataset.name;
        component.set("v.selectedType",selectedType);
        component.set("v.hideSummary",false);
        component.set("v.isEmail",false);
        component.set("v.isFAQ",true);
    },
    closeFAQDetails : function(component, event, helper){
    	var faqHeight =event.getParam("dropDownHeightNew");
        //console.log('==faqHeight==11='+faqHeight);
        component.set("v.FAQDropDownHeight",faqHeight);
        component.set("v.hideSummary",true);
        component.set("v.isEmail",false);
        component.set("v.isFAQ",false);
    }
})