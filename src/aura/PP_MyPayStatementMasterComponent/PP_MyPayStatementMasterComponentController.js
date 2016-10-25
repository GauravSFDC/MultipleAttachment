({
    loadYear : function(component, event, helper) {
        component.set("v.hideDetails",true);
        component.set("v.isSummaryClicked",false);
        var action = component.get("c.intCurrentYear");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                component.set("v.currentYear",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        
        var toggleText = component.find("secondpage1");
        $A.util.addClass(toggleText, 'invisible');
        $A.enqueueAction(action);
        var action1 = component.get("c.getCurrentYear");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                component.set("v.currentYearVal",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action1);
    },
    afterScriptsLoaded : function(component, event, helper) {
        console.log('====jQuery=');
    },
    showSpinner : function (component, event, helper) {
        var toggleText = component.find("spinner");
        $A.util.removeClass(toggleText,'toggle');
        //console.log('====jQuery='+jQuery('.dropdown-item'));
    },
   /* doAction : function(cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.param1;
            console.log("param1: " + param1);
            // add your code here
            jQuery('#dropdown-list').css("height","0");
            jQuery('.dropdown-item:first').addClass('current-item');
            jQuery("#dropdown-head").on("click", function(e) {
                jQuery("#dropdown-head").toggleClass("active");
                e.stopPropagation()
                if(jQuery("#dropdown-head").hasClass("active") == true)
                {
                    jQuery('#dropdown-list').css("height",param1);
                    console.log('dropdownclick'+param1);
                }
                else
                    jQuery('#dropdown-list').css("height","0");
            });
            jQuery(document).on("click", function(e) {
                if (jQuery(e.target).is("#dropdown-head") === false) {
                    jQuery("#dropdown-head").removeClass("active");
                    jQuery('#dropdown-list').css("height","0");
                }
            });
            jQuery('.dropdown-item').on("click", function(){
                var selectedDropdownText = jQuery(this).text();
                jQuery('#dropdown-head').html(selectedDropdownText);
                jQuery('.dropdown-item').removeClass('current-item');
                jQuery(this).addClass('current-item');
            });
        }
    },*/
    
    hideSpinner : function (component, event, helper) {
        var toggleText = component.find("spinner");
        $A.util.addClass(toggleText,'toggle');
        if(typeof(jQuery) != "undefined"){
            var cssScrolltoTop = jQuery(".scroller"); // css class to find scroll position
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
        /*    jQuery('.dropdown-item').each(function(e){
                if(component.get("v.selectedYear") == $(this).text()){
                    $(this).addClass('current-item');
                    jQuery('#dropdown-head').html($(this).text());
                }
            });
            var dropdownHeight = jQuery('#dropdown-list').height();
            //console.log('dropdownHeight==first=='+dropdownHeight);
            if(dropdownHeight != undefined && dropdownHeight !=0){
                component.set("v.dropdownHeight",dropdownHeight);
                var dropHeight = JSON.stringify(component.get("v.dropdownHeight"));
                //console.log('dropdownHeightif'+parseInt(dropHeight));
                jQuery('#dropdown-list').css("height","0");
                
                jQuery('.dropdown-item:first').addClass('current-item');
              
            //console.log('isStopExecution'+component.get("v.isStopExecution"))
            if(component.get("v.isStopExecution") == true){
                //console.log('dropdownHeightif===='+component.get("v.dropdownHeight"));
                var dropHeight = JSON.stringify(component.get("v.dropdownHeight"));
                component.set("v.isStopExecution",false)
            jQuery("div#shyCustomDropdown").on('click','#dropdown-head', function(e) {
                jQuery("#dropdown-head").toggleClass("active");
                if(jQuery("#dropdown-head").hasClass("active") == true)
                {
                    jQuery('#dropdown-list').css("height",parseInt(dropHeight)-100);
                    //console.log('dropdownclicklist'+parseInt(dropHeight));
                }
                else
                    jQuery('#dropdown-list').css("height","0");
            });
            jQuery(document).on("click", function(e) {
                if (jQuery(e.target).is("#dropdown-head") === false) {
                    jQuery("#dropdown-head").removeClass("active");
                    jQuery('#dropdown-list').css("height","0");
                }
            });
            jQuery('#dropdown-list li.dropdown-item').on("click", function(){
                var selectedDropdownText = jQuery(this).text();
                jQuery('#dropdown-head').html(selectedDropdownText);
                jQuery('.dropdown-item').removeClass('current-item');
                jQuery(this).addClass('current-item');
            });
           
            }
            }
            if(component.get("v.isSummaryClicked")== true){
               // console.log('dropdownHeightif===='+component.get("v.dropdownHeight"));
                var dropHeight = JSON.stringify(component.get("v.dropdownHeight"));
                component.set("v.isSummaryClicked",false)
            jQuery("div#shyCustomDropdown").on('click','#dropdown-head', function(e) {
                jQuery("#dropdown-head").toggleClass("active");
                if(jQuery("#dropdown-head").hasClass("active") == true)
                {
                    jQuery('#dropdown-list').css("height",parseInt(dropHeight));
                    console.log('dropdownclicklist===='+parseInt(dropHeight));
                }
                else
                    jQuery('#dropdown-list').css("height","0");
            });
            jQuery(document).on("click", function(e) {
                if (jQuery(e.target).is("#dropdown-head") === false) {
                    jQuery("#dropdown-head").removeClass("active");
                    jQuery('#dropdown-list').css("height","0");
                }
            });
            jQuery('#dropdown-list li.dropdown-item').on("click", function(){
                var selectedDropdownText = jQuery(this).text();
                jQuery('#dropdown-head').html(selectedDropdownText);
                jQuery('.dropdown-item').removeClass('current-item');
                jQuery(this).addClass('current-item');
            });
            } */
        }
    },
    gotEvent: function(component, event, helper) {
        component.set("v.hideDetails",false);
    },
    gotSummaryEvent : function(component, event, helper) {
        component.set("v.hideDetails",true);
        component.set("v.isSummaryClicked",true);
        component.set("v.isCallFunction",false);
        component.set("v.isCallFunction",true);
    },
    showError : function(component, event, helper) {
       // console.log(component.get("v.selectedYear"));
        component.set("v.showError",true);
    },
    
    currentYear : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.name;
        console.log('=selectedItemYear='+Name);
        component.set("v.showError",false);
        component.set("v.selectedYear",Name);
        component.set("v.selectedYearVal",Name);
        component.set("v.isCallFunction",false);
        component.set("v.isCallFunction",true);
       /* jQuery('.dropdown-item').each(function(e){
                if(component.get("v.selectedYear") == $(this).text()){
                    $(this).addClass('current-item');
                }
            });*/
        //jQuery(".noName").addClass("active");
        
    },
    gotEmailEvent : function(component, event, helper){
        component.set("v.hideDetails",true);
        component.set("v.isCallFunction",false);
        component.set("v.isCallFunction",true);
    },
    changeYear : function(component, event, helper){
       // var selectedItem = event.currentTarget;
       // var Name = selectedItem.dataset.name;
        var selectCmp = component.find("InputSelectSingle");
        //console.log('==selectCmp=='+selectCmp.get("v.value"));
        component.set("v.showError",false);
        component.set("v.selectedYear",selectCmp.get("v.value"));
        component.set("v.selectedYearVal",selectCmp.get("v.value"));
        component.set("v.isCallFunction",false);
        component.set("v.isCallFunction",true);
    },
})