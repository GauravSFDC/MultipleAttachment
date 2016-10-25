/***------------------------------------------------------------------------------------------------------------***
* File Name         :  PP_MyPaySlip_API_Controller_MockResponse 
* Description       :  Mock response for Test class(My Pay Summary - People Portal)
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***-------------------------------------------------------------------------------------------------------------***/


public class PP_MyPaySlip_API_Controller_MockResponse{

    public String mockResponse(){
        String mock ='{"PAY_SUMMARY" :{"BAPI_GET_PAYSLIP" : {"@id" : "1","import" : {"EMPLOYEENUMBER" : "00042564","PAYSLIPVARIANT" : null,"SEQUENCENUMBER" : "00453"},'+
                    '"tables" : {"PAYSLIP" : {"row" : [ {"@id" : "4","FORMAT_COL" : "/","TEXT_COL" : "|||PAY DATE:01/29/2010|"}, '+
                    '{"@id" : "5","FORMAT_COL" : "/","TEXT_COL" : "|||PAYROLL PERIOD:  01/16/2010- 01/31/2010  |"}, '+
                    '{"@id" : "15","FORMAT_COL" : "/","TEXT_COL" : "||  PAID EARNINGS|TAXES|  DEDUCTIONS|NET PAY|Direct Dep|2,559.01|"}, '+
                    '{"@id" : "16","FORMAT_COL" : "/","TEXT_COL" : "|-------------------------------------------------------------------------|||"},'+
                    '{"@id" : "17","FORMAT_COL" : "/","TEXT_COL" : "|CUR  |  4,623.23|1,068.16  |  996.06  |2,559.01|||"}, '+
                    '{"@id" : "18","FORMAT_COL" : "/","TEXT_COL" : "|YTD  | 9,246.46|2,062.77  |1,992.12  |5,191.57|||"}]}}}}}';
        return mock;
    }
     public String mockResponseEmail(){
        String mockEmail ='{"ERRORDESCRIPTION" : "Email send not successfully!"}';
        return mockEmail;
    }
 
}