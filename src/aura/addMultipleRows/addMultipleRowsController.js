({
    doInit : function(component, event, helper) {
        var countRows = component.get("v.countRows");            
        var myResults =[];
        for (var total = 0,i = 0; i <countRows; i++) { 
            total += myResults[i];
            myResults.push(i);
        }    
        component.set('v.countLst',myResults);
    },
    addMultiple : function(component,event,helper){
        var counter = component.get("v.countRows");
        counter++;
        component.set("v.countRows",counter);
        var countRows = component.get("v.countRows");            
        var myResults =[];
        for (var total = 0,i = 0; i <countRows; i++) { 
            total += myResults[i];
            myResults.push(i);
        }    
        component.set('v.countLst',myResults);
    },
    deleteMultiple : function(component,event,helper){
        var counter = component.get("v.countRows");
        counter--;
        component.set("v.countRows",counter);
        var countRows = component.get("v.countRows");            
        var myResults =[];
        for (var total = 0,i = 0; i <countRows; i++) { 
            total += myResults[i];
            myResults.push(i);
        }    
        component.set('v.countLst',myResults);
    },
    addAllAttachments: function(component,event,helper){
        var parentId =event.getParam("ParentId");
        
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var fr = new FileReader();
        
        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            
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
    }
})