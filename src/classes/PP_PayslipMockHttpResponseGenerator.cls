/***------------------------------------------------------------------------------------------------------------***
* File Name         :  PP_PayslipMockHttpResponseGenerator  
* Description       :  Mock controller for Integration Test classes(My Pay Summary - People Portal)
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***-------------------------------------------------------------------------------------------------------------***/

@isTest
global class PP_PayslipMockHttpResponseGenerator implements HttpCalloutMock {
    Static final string EndPoint = 'http://abid-people-portal-sap.cloudhub.io/abi?METHOD=getpaysummary&EMPLOYEENUMBER=00042564&FROMDATE=2010-01-01&TODATE=2010-08-31';
    Static final string EmailEnpoint = 'http://abid-people-portal-sap.cloudhub.io/abi?METHOD=sendpdfemail&EMPLOYEENUMBER=00042564&FIRSTNAME=JANANI&LASTNAME=RAMAKRISHNAN&SEQUENCENUMBER=00466&FROMADDR=Invalid.Address@anheuser-busch.com&TOADDR=janani.ramakrishnan@cognizant.com&BODY=%3Cb%3E%3Cfont%20color=%27red%27%3EAttach%20is%20your%20pay%20statement%3C/font%3E%3C/b%3E%3Cbr%3E%3Ci%3E%3Cfont%20color=%27red%27%3EAttach%20is%20your%20pay%20statement%3C/font%3E%3C/i%3E&SUBJECT=Payslip%20for%20the%20period';
        global HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            if(req.getEndpoint() == EndPoint) {
            res.setBody('{"foo":"bar"}');
            } else if (req.getEndpoint() == EmailEnpoint) {
            res.setBody('{"foo":"bar"}');
            }
            return res;
        }

}