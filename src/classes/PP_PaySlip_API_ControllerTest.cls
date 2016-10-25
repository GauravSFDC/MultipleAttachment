/***-------------------------------------------------------------------------------------------***
* File Name         :  PP_PaySlip_API_ControllerTest
* Description       :  Test Class for apex classes used for My Pay Summary - People Portal
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***---------------------------------------------------------------------------------------------***/

@isTest
private class PP_PaySlip_API_ControllerTest {
   @isTest
     static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new PP_PayslipMockHttpResponseGenerator());
        HttpResponse res = PP_PaySlip_API_Controller.makecallout('00042564', '2010-01-01', '2010-08-31');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    
    @isTest
     static void testCalloutEmail() {
        Test.setMock(HttpCalloutMock.class, new PP_PayslipMockHttpResponseGenerator());
        HttpResponse res = PP_PaySlip_API_Controller.sendEmail('00042564', 'JANANI', 'RAMAKRISHNAN', '00466', 'Invalid.Address@anheuser-busch.com', 'janani.ramakrishnan@cognizant.com' , '%3Cb%3E%3Cfont%20color=%27red%27%3EAttach%20is%20your%20pay%20statement%3C/font%3E%3C/b%3E%3Cbr%3E%3Ci%3E%3Cfont%20color=%27red%27%3EAttach%20is%20your%20pay%20statement%3C/font%3E%3C/i%3E', 'Payslip%20for%20the%20period');
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        //System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
    
     @isTest
     static void testMypayslipCntrl() {
         PP_MyPaySlip_Cntrl mp = new PP_MyPaySlip_Cntrl ();
         
         Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
         User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'testton@asdf.com',
                           Username = 'test.test@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        Insert usr;
        
        Account acc = new Account();
        acc.LastName = 'test';
        acc.ownerid= UserInfo.getUserId();
        acc.PP_Employee_Number__c = '12345';
        acc.PersonEmail = 'testton@asdf.com';
        Date hireDate = date.newinstance(2005, 02, 17);
        acc.PP_Hiring_Date__c = hireDate;
        acc.PP_Employee_Number__c = '00042564';
        insert acc;
        
        acc.PP_SendPushNotification__c=true;
        update acc;
        
        PP_FAQ_Category__c c = new PP_FAQ_Category__c();
        c.Name = 'TestC';
        c.PP_Category_Type__c = 'Payroll';
        insert c;
        
        PP_FAQ_SubCategory__c sqa = new PP_FAQ_SubCategory__c();
        sqa.Name = 'TestSQA';
        sqa.Description__c = 'Sample Desc';
        sqa.PP_Subcategory_Type__c = 'Net Pay';
        sqa.PP_FAQ_Category__c =c.Id;
        insert sqa;
        
        
        PP_FAQ_QA__c qa = new PP_FAQ_QA__c();
        qa.Name = 'TestQA';
        qa.PP_Answer__c = 'Sample Answer';
        qa.PP_Question__c ='Sample Question';
        qa.SINumber__c = 5;
        qa.PP_FAQ_SubCategory__c = sqa.Id;
        insert qa;
        
        System.runAs(usr){
            PP_MyPaySlip_Cntrl.strEmailAddress();
            PP_MyPaySlip_Cntrl.getCurrentYear();
            PP_MyPaySlip_Cntrl.intCurrentYear();
            PP_MyPaySlip_Cntrl.lstSortMonth();
            PP_MyPaySlip_Cntrl.lstPay('"2010"');
            PP_MyPaySlip_Cntrl.invokePayStubAPI_sendEmail('06/03/2010','00466','testton@asdf.com');
            PP_MyPaySlip_Cntrl.lstFAQ('Net Pay');
            PP_MyPaySlip_Cntrl.lstSubCategoryFaqs('Net Pay');
            PP_MyPaySlip_Cntrl.FAQDescriptions('Net Pay');
            
            
            PP_MyPaySlip_Cntrl.Wrapper_PayrollDetailResults wpr = new PP_MyPaySlip_Cntrl.Wrapper_PayrollDetailResults();
            
            wpr.getPayrollDetailResults(15,'0|0|200|200|300|20|100|200|','1000','00042564');
            wpr.getPayrollDetailResults(16,'0|0|200|200|300|20|100|200|','1000','00042564');
            wpr.getPayrollDetailResults(17,'0|0|200|200|300|20|100|200|','1000','00042564');
            wpr.getPayrollDetailResults(18,'0|0|200|200|300|20|100|200|','1000','00042564');
        }
        
        PP_PdfJsonMsg pjm = new PP_PdfJsonMsg();
        PP_PdfJsonMsg.parse('{"ERRORDESCRIPTION" : "Email send successfully!"} ');
        
        PP_PayslipJsontoApex pja = new PP_PayslipJsontoApex();
        PP_PayslipJsontoApex.parse('{"PAY_SUMMARY" :{"BAPI_GET_PAYSLIP" : [ {"@id" : "1","import" : {"EMPLOYEENUMBER" : "00042564","PAYSLIPVARIANT" : null,"SEQUENCENUMBER" : "00453"},'+
                    '"tables" : {"PAYSLIP" : {"row" : [ {"@id" : "4","FORMAT_COL" : "/","TEXT_COL" : "|||PAY DATE:01/29/2010|"}, '+
                    '{"@id" : "5","FORMAT_COL" : "/","TEXT_COL" : "|||PAYROLL PERIOD:  01/16/2010- 01/31/2010  |"}, '+
                    '{"@id" : "15","FORMAT_COL" : "/","TEXT_COL" : "||  PAID EARNINGS|TAXES|  DEDUCTIONS|NET PAY|Direct Dep|2,559.01|"}, '+
                    '{"@id" : "16","FORMAT_COL" : "/","TEXT_COL" : "|-------------------------------------------------------------------------|||"},'+
                    '{"@id" : "17","FORMAT_COL" : "/","TEXT_COL" : "|CUR  |  4,623.23|1,068.16  |  996.06  |2,559.01|||"}, '+
                    '{"@id" : "18","FORMAT_COL" : "/","TEXT_COL" : "|YTD  | 9,246.46|2,062.77  |1,992.12  |5,191.57|||"}]}}},'+
                    '{"@id" : "2","import" : {"EMPLOYEENUMBER" : "00042564","PAYSLIPVARIANT" : null,"SEQUENCENUMBER" : "00453"},'+
                    '"tables" : {"PAYSLIP" : {"row" : [ {"@id" : "4","FORMAT_COL" : "/","TEXT_COL" : "|||PAY DATE:01/29/2010|"}, '+
                    '{"@id" : "5","FORMAT_COL" : "/","TEXT_COL" : "|||PAYROLL PERIOD:  01/16/2010- 01/31/2010  |"}, '+
                    '{"@id" : "15","FORMAT_COL" : "/","TEXT_COL" : "||  PAID EARNINGS|TAXES|  DEDUCTIONS|NET PAY|Direct Dep|2,559.01|"}, '+
                    '{"@id" : "16","FORMAT_COL" : "/","TEXT_COL" : "|-------------------------------------------------------------------------|||"},'+
                    '{"@id" : "17","FORMAT_COL" : "/","TEXT_COL" : "|CUR  |  4,623.23|1,068.16  |  996.06  |2,559.01|||"}, '+
                    '{"@id" : "18","FORMAT_COL" : "/","TEXT_COL" : "|YTD  | 9,246.46|2,062.77  |1,992.12  |5,191.57|||"}]}}}]}}');
            
  
     }
}