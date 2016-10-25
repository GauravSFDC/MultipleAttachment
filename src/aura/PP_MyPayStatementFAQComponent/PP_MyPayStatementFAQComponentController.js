({
    doInit : function(component, event, helper) {
        component.set("v.showFAQDropdown",true);
        component.set("v.showFAQTypes"	,true);
        var selectedType = component.get("v.selectedType");
        //console.log('checkEl==='+JSON.stringify(selectedType));
        //$('#dropdown-head-faq').html(JSON.stringify(selectedType));
      // component.find("FAQType").set("v.value",selectedType);
        var action = component.get("c.lstSubCategoryFaqs");
        action.setParams({
            "strFAQType" : selectedType
        });
        action.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.lstFAQSubCategories",response.getReturnValue());
            }
        });
         $A.enqueueAction(action); 
        var QuestionAction = component.get("c.lstFAQ");
        QuestionAction.setParams({
            "strCategory" : selectedType
        });
        QuestionAction.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.lstFAQQuestions",response.getReturnValue());
                if(component.get("v.lstFAQQuestions") != '')
                    component.set("v.showFAQText",true);
            }
        });
        $A.enqueueAction(QuestionAction);
        
        var FAQDescript = component.get("c.FAQDescriptions");
        FAQDescript.setParams({
            "strCategory" : selectedType
        });
        FAQDescript.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.FAQDescriptions",response.getReturnValue());
            }
        });
        $A.enqueueAction(FAQDescript);
        
    }, 
    openDropDown : function(component, event, helper){
    	//var dropdownHeight = $('#dropdown-list-faq').height();
       // console.log('====dropdownHeight**'+dropdownHeight);
		
    },
    closeFAQ: function(component, event, helper){
        component.set("v.showFAQDropdown",true);
        var dropDownHeight = JSON.stringify(component.get("v.faqdropLength"));
        var myEvent = $A.get("e.c:PP_MyPayStatementFAQEvent");
        $A.get("e.c:PP_MyPayStatementFAQDropdownHeightEvent").setParams({dropDownHeightNew: dropDownHeight}).fire();
        myEvent.fire();
    },
    selectFAQCategory :function(component, event, helper){
        component.set("v.showFAQText",false);
        var selectCmp = component.find("InputSelectSingle");
        var QuestionAction = component.get("c.lstFAQ");
        QuestionAction.setParams({
            "strCategory" : selectCmp.get("v.value")
        });
        QuestionAction.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.lstFAQQuestions",response.getReturnValue());
                if(component.get("v.lstFAQQuestions") != '')
                    component.set("v.showFAQText",true);
            }
        });
        $A.enqueueAction(QuestionAction);
        var FAQDescript = component.get("c.FAQDescriptions");
        FAQDescript.setParams({
            "strCategory" : selectCmp.get("v.value")
        });
        FAQDescript.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.FAQDescriptions",response.getReturnValue());
            }
        });
        $A.enqueueAction(FAQDescript);
    },
    openQuestion : function(component, event, helper){
        
        var cssScrolltoTop = $(".scroller"); // css class to find scroll position
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
    	var selectedItem 		= event.currentTarget;
        var selectedQuestion 	= selectedItem.dataset.question;  
        var selectedAnswer 		= selectedItem.dataset.answer;
        var selectedtype 		= selectedItem.dataset.type;
        component.set("v.FAQQuestion",selectedQuestion);
        component.set("v.FAQAnswer"	,selectedAnswer);
        component.set("v.FAQType"	,selectedtype);
        component.set("v.showFAQTypes"	,false);
    },
    closeQuestion : function(component, event, helper){
        var selectedItem 		= event.currentTarget;
        var selectedQuestion 	= selectedItem.dataset.questype;
       // $('#dropdown-head-faq').children("span").text(selectedQuestion);
        console.log('faqSelType==='+selectedQuestion);
       // component.find("InputSelectSingle").set("v.value",selectedType);
        // $('#dropdown-head-faq').html(selectedQuestion);
        //component.set("v.showFAQDropdown",true);
        var selectedType = selectedQuestion;
        //console.log('checkEl==='+JSON.stringify(selectedType));
        //$('#dropdown-head-faq').html(JSON.stringify(selectedType));
      // component.find("FAQType").set("v.value",selectedType);
        var action = component.get("c.lstSubCategoryFaqs");
        action.setParams({
            "strFAQType" : selectedType
        });
        action.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.lstFAQSubCategories",response.getReturnValue());
            }
        });
         $A.enqueueAction(action); 
        component.set("v.showFAQTypes"	,true);
    },
    selectFAQCategoryDrop : function(component, event, helper){
        component.set("v.showFAQText",false);
        var selectedItem = event.currentTarget;
        var selectCmp = selectedItem.dataset.name;
        //var selectCmp = component.find("InputSelectSingle");
        var QuestionAction = component.get("c.lstFAQ");
        QuestionAction.setParams({
            "strCategory" : selectCmp
        });
        QuestionAction.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.lstFAQQuestions",response.getReturnValue());
                if(component.get("v.lstFAQQuestions") != '')
                    component.set("v.showFAQText",true);
            }
        });
        $A.enqueueAction(QuestionAction);
        var FAQDescript = component.get("c.FAQDescriptions");
        FAQDescript.setParams({
            "strCategory" : selectCmp
        });
        FAQDescript.setCallback(this,function(response){
            if(component.isValid() && response.getState() === 'SUCCESS'){
                component.set("v.FAQDescriptions",response.getReturnValue());
            }
        });
        $A.enqueueAction(FAQDescript);
    },
    doneRendering: function(cmp, event, helper) {
        var dropdownHeight = $('#dropdown-list-faq').height();
        //console.log('====dropdownHeightdone**'+cmp.get("v.faqdropLength"));
    
        if(dropdownHeight !==0){
            if(cmp.get("v.showFAQDropdown") == true){
                console.log('2ndTime')
                cmp.set("v.showFAQDropdown",false);
                cmp.set("v.faqdropLength", dropdownHeight)
            $('#dropdown-list-faq').css("height","0");
           // cmp.set("v.dropdownHeight",true);
         //   if(cmp.get("v.dropdownHeight") == true){
        //   cmp.set("v.dropdownHeight",false); 
        var dropdownItemHeight = $('.dropdown-item-faq').height();
		
		$("#dropdown-head-faq").on("click", function(e) {
            //alert("kjh");
			$("#dropdown-head-faq").toggleClass("active");
			e.stopPropagation()
			if($("#dropdown-head-faq").hasClass("active") == true)
			{
				$('#dropdown-list-faq').css("height",dropdownHeight);
			}
			else
				$('#dropdown-list-faq').css("height","0");
		});
		$(document).on("click", function(e) {
			if ($(e.target).is("#dropdown-head-faq") === false) {
				$("#dropdown-head-faq").removeClass("active");
				$('#dropdown-list-faq').css("height","0");
			}
		});
		$('.dropdown-item-faq').on("click", function(){
			var selectedDropdownText = $(this).text();
			$('#dropdown-head-faq').html(selectedDropdownText);
			$('.dropdown-item-faq').removeClass('current-item');
			$(this).addClass('current-item');
			console.log(selectedDropdownText);
		});
        }
        }
      /*  if(JSON.stringify(cmp.get("v.faqdropLength")) != undefined){
            if(JSON.stringify(cmp.get("v.faqdropLength")) != 0){
           // console.log('JA RHA HAI');
            if(cmp.get("v.showFAQDropdown") == true){
                var actualHeight = JSON.stringify(cmp.get("v.faqdropLength")).substr(1, 3);
               // console.log('1ndTime')
                cmp.set("v.showFAQDropdown",false);
            $('#dropdown-list-faq').css("height","0");
           // cmp.set("v.dropdownHeight",true);
         //   if(cmp.get("v.dropdownHeight") == true){
        //   cmp.set("v.dropdownHeight",false); 
        var dropdownItemHeight = $('.dropdown-item-faq').height();
		
		$("#dropdown-head-faq").on("click", function(e) {
            //alert("kjh");
			$("#dropdown-head-faq").toggleClass("active");
			e.stopPropagation()
			if($("#dropdown-head-faq").hasClass("active") == true)
			{
               // var eventstring = new String();
                //eventstring = JSON.stringify(cmp.get("v.faqdropLength")).toString().replace(/"/g, "");
               // eval(eventstring );
             //  var test = JSON.stringify(cmp.get("v.faqdropLength"));
             //  console.log(test);
			//	console.log(test.replace(/\"/g, "")); 
                 console.log('1ndTime=='+JSON.stringify(cmp.get("v.faqdropLength")).substr(1, 3))
				$('#dropdown-list-faq').css("height",actualHeight);
			}
			else
				$('#dropdown-list-faq').css("height","0");
		});
		$(document).on("click", function(e) {
			if ($(e.target).is("#dropdown-head-faq") === false) {
				$("#dropdown-head-faq").removeClass("active");
				$('#dropdown-list-faq').css("height","0");
			}
		});
		$('.dropdown-item-faq').on("click", function(){
			var selectedDropdownText = $(this).text();
			$('#dropdown-head-faq').html(selectedDropdownText);
			$('.dropdown-item-faq').removeClass('current-item');
			$(this).addClass('current-item');
			console.log(selectedDropdownText);
		});
        }
        }
        }*/
       /* console.log('dropdownHeightFAQ=1100='+jQuery('.dropdown-item-faq').height());
        jQuery(document).ready(function(){
		var dropdownHeight = jQuery('#dropdown-list-faq').height();
            console.log('dropdownHeightFAQ'+dropdownHeight);
		var noOfItems = 4;
		var dropdownItemHeight = jQuery('.dropdown-item-faq').height();
            console.log('dropdownHeightFAQ=='+jQuery('.dropdown-item-faq').height());
            alert(jQuery('#dropdown-list-faq').height());
		jQuery('#dropdown-list-faq').css("height","0");
		jQuery("#dropdown-head-faq").on("click", function(e) {
            
			jQuery("#dropdown-head-faq").toggleClass("active");
			e.stopPropagation()
			if(jQuery("#dropdown-head-faq").hasClass("active") == true)
			{
				jQuery('#dropdown-list-faq').css("height",dropdownHeight);
			}
			else
				jQuery('#dropdown-list-faq').css("height","0");
		});
		jQuery(document).on("click", function(e) {
			if (jQuery(e.target).is("#dropdown-head-faq") === false) {
				jQuery("#dropdown-head-faq").removeClass("active");
				jQuery('#dropdown-list-faq').css("height","0");
			}
		});
		jQuery('.dropdown-item-faq').on("click", function(){
			var selectedDropdownText = jQuery(this).text();
			jQuery('#dropdown-head-faq').html(selectedDropdownText);
			jQuery('.dropdown-item-faq').removeClass('current-item');
			jQuery(this).addClass('current-item');
			console.log(selectedDropdownText);
		});
	});*/
    }
    
})