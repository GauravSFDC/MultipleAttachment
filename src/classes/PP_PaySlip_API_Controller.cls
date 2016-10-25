/***-----------------------------------------------------------------------------------------------***
* File Name         :  PP_PaySlip_API_Controller 
* Description       :  Integration Controller - SAP - ESS (My Pay Summary - People Portal)
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***-------------------------------------------------------------------------------------------------***/

public class PP_PaySlip_API_Controller {
     
     public static HttpResponse makeCallout(String EmployeeNumber, String FromDate, String ToDate){
        
        Http h = new Http();            
        HttpRequest req = new HttpRequest();
        String endpoint;
        req.setHeader('Content-Type', 'application/json');        
        req.setMethod('GET');
        req.setTimeout(120000);
        endpoint = System.Label.PP_SF_MULESAP+'METHOD=getpaysummary&EMPLOYEENUMBER='+EmployeeNumber+'&FROMDATE='+FromDate+'&TODATE='+ToDate;
        req.setEndpoint(endpoint);
        HttpResponse res = h.send(req);        
        system.debug('!!!!!!Jan!!!!!!!!'+res);
        return res;
    }
    
      public static HttpResponse sendEmail(String EmployeeNumber, String Firstname, String LastName, String SequenceNumber,String FromAddr, String ToAddr, String subject, String mailbody ){
        system.debug('==checkSubject==='+subject);
        Http h = new Http();            
        HttpRequest req = new HttpRequest();
        String endpoint;
        String resource;
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');  
//        req.setBody(body); 
        endpoint = System.Label.PP_SF_MULESAP+'METHOD=sendpdfemail&EMPLOYEENUMBER='+EmployeeNumber+'&FIRSTNAME='+Firstname+'&LASTNAME='+LastName+'&SEQUENCENUMBER='+SequenceNumber+'&FROMADDR='+FromAddr+'&TOADDR='+ToAddr+'&BODY='+mailbody +'&SUBJECT='+subject+'';
        req.setEndpoint(endpoint);
        HttpResponse res = h.send(req);        
        String jsonString = res.getBody();
        return res;
    }
  }