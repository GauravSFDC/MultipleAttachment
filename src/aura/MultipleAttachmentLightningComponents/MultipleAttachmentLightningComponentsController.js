({
    save : function(component) {
        
      //  MAX_FILE_SIZE =  750 000, /* 1 000 000 * 3/4 to account for base64 */
        var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];
   
//        if (file.size > this.MAX_FILE_SIZE) {
      //      alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    	//          'Selected file size: ' + file.size);
    //	    return;
      //  }
    
        var fr = new FileReader();
        
        var self = this;
       	fr.onload = function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);
        
    	    //helper.upload(component, file, fileContents);
    	    var action = component.get("c.saveTheFile"); 

        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });

        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            console.log(attachId);
        });
            
        $A.run(function() {
            $A.enqueueAction(action); 
        });
        };

        fr.readAsDataURL(file);
        if(component.get("v.countRows") != 0){
            var parentId = component.get("v.parentId");
            //component.getEvent("PP_OpenMyPaySummaryMaster");
           $A.get("e.c:MultipleAttachmentEvent").setParams({ParentId: parentId}).fire();
        }
    },
    addMultiple : function(component,event,helper){
       var counter = component.get("v.countRows");
       counter++;
       component.set("v.countRows",counter);
        component.set("v.isAddMultiple",false);
        component.set("v.isAddMultiple",true);
    },
    deleteMultiple : function(component,event,helper){
       var counter = component.get("v.countRows");
       counter--;
       component.set("v.countRows",counter);
        component.set("v.isAddMultiple",false);
        component.set("v.isAddMultiple",true);
    },
    showSpinner : function (component, event, helper) {
        var toggleText = component.find("spinner");
        $A.util.removeClass(toggleText,'toggle');
    },
    hideSpinner : function (component, event, helper) {
        var toggleText = component.find("spinner");
        $A.util.addClass(toggleText,'toggle');
    },
})