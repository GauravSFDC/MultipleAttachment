public class PP_PayStatement_Controller {
    public List<Wrapper_PaydateResults> lstResults{get; set;}
    public String EmployeeNumber{get;set;}
    public String SeqNumber{get;set;}
    public Static Account accObj{get;set;}
    public String emailMsg;
    public PP_PayStatement_Controller(){
        
    } 
    @AuraEnabled 
    public static String strEmailAddress(){ 
        User userObj = [Select Id, Name, Email from User where Id =: UserInfo.getUserId()];
        accObj = [Select Id, Name, OwnerId, PersonEmail, PP_Employee_Number__c, PP_Hiring_Date__c from Account
                    where OwnerId =: userObj.Id LIMIT 1];
        return userObj.Email;
    } 
    
    @AuraEnabled
    public static String getCurrentYear(){
        return String.valueOf(system.today().year());
    }
    @AuraEnabled
    public static List<String> intCurrentYear(){
        User userObj = [Select Id, Name, Email from User where Id =: UserInfo.getUserId()];
        accObj = [Select Id, Name, OwnerId, PersonEmail, PP_Employee_Number__c, PP_Hiring_Date__c from Account
                    where OwnerId =: userObj.Id LIMIT 1];
        
        List<String> lstIntegers = New List<String>();
        for(Integer i=system.today().year();i>=(accObj.PP_Hiring_Date__c).year();i--){
            lstIntegers.add(String.valueOf(i));    
        }
        return lstIntegers; 
    }
    @AuraEnabled 
    public static List<String> lstSortMonth(){
        List<String> lstMonthNumber = New List<String>();
        lstMonthNumber.add('12');lstMonthNumber.add('11');
        lstMonthNumber.add('10');lstMonthNumber.add('09');
        lstMonthNumber.add('08');lstMonthNumber.add('07');
        lstMonthNumber.add('06');lstMonthNumber.add('05');
        lstMonthNumber.add('04');lstMonthNumber.add('03');
        lstMonthNumber.add('02');lstMonthNumber.add('01');
        return lstMonthNumber;
    }
    @AuraEnabled
    public static void invokePayStubAPI_sendEmail( String Paydate, String SeqNumber, String EmailAddress){
        System.debug('--------------' +SeqNumber);
        User userObj = [Select Id, Name, Email from User where Id =: UserInfo.getUserId()];
        accObj = [Select Id, Name, OwnerId, FirstName, LastName,PersonEmail, PP_Employee_Number__c, PP_Hiring_Date__c from Account
                          where OwnerId =: userObj.Id LIMIT 1];
        String emailMsg;

     HttpResponse resp;
     String EmpNumber = accObj.PP_Employee_Number__c;
     String Firstname = accObj.FirstName;
     String LastName = accObj.LastName;
     String ToAddress = EmailAddress;
     String FromAdd = 'AB%20Payroll%20Employee%20Services%20<Invalid.Address@Anheuser-Busch.com>';
     String emailSubject = 'Pay%20Statement%20for%20'+Paydate;
     String emailcontent ='<p></p>%20<center><font%20size="3"%20color="black">%20Your%20ABI%20Pay%20Summary%20for%20period%20'+Paydate+'%20is%20available%20for%20view.%20</p><p>%20If%20you%20have%20any%20questions%20related%20to%20the%20electronic%20pay%20statement%20,%20please%20contact%20the%20Business%20Services%20Center%20at%201-800-233-7825%20or%20email%20<font%20color="Blue"><U>Contact%20Center%20(STL)</U></font>';
    // String emailcontent = '<p></p>%20<center><font%20size="3"%20color="black">Attached%20is%20your%20Pay%20Statement%20for:%20'+Paydate+'%20<br>%20<br>%20In%20order%20to%20open%20the%20attachment%20you%20will%20need%20an%20Adobe%20Acrobat%20reader.%20<br>%20You%20can%20download%20Adobe%20Acrobat%20Reader%20for%20free,%20by%20going%20to:%20<a%20href="http://get.adobe.com/reader/otherversions/">%20Adobe%20Reader</a>%20<br>%20<br>%20You%20will%20be%20asked%20for%20a%20password%20key%20when%20you%20open%20the%20PDF%20file.%20<br>%20<br>%20</font><font%20size="4"%20color="red"><b>***Please%20do%20not%20reply%20to%20this%20message***%20</b>%20</font></center>%20<font%20size="3"%20color="black"><br>%20<b>This%20email%20was%20not%20sent%20from%20a%20valid%20mailbox.%20</b>If%20you%20have%20any%20questions%20related%20to%20the%20electronic%20pay%20statement,%20please%20contact%20the%20Business%20Services%20Center%20at%201-800-233-7825%20or%20email%20<a%20href="mailto:ContactCenter@Anheuser-Busch.com">Contact%20Center%20(STL)</a>.%20Thank%20you.%20<br>%20</font>%20<p></p>%20<hr>%20<font%20size="1"%20face="verdana"%20color="gray">Anheuser-Busch%20InBev%20Email%20Disclaimer%20<a%20href="http://www.ab-inbev.com/disclaimer.cfm">%20www.ab-inbev.com</a>%20</font>';
     String JsonString;
     PP_PdfJsonMsg obj = new PP_PdfJsonMsg();
     
     if(!Test.isRunningTest()){
         resp= PP_PaySlip_API_Controller.SendEmail(EmpNumber, Firstname, LastName, SeqNumber, FromAdd, ToAddress, emailSubject, emailContent);
         JsonString = resp.getBody();
         obj= PP_PdfJsonMsg.parse(JsonString);
         if(obj.ERRORDESCRIPTION.Contains('Email send successfully')){
            emailMsg = obj.ERRORDESCRIPTION;
          }
    }    
        else
        {
           PP_MyPaySlip_API_Controller_MockResponse mr= new PP_MyPaySlip_API_Controller_MockResponse();
           jsonString = mr.mockResponseEmail();
        }

  }
    
    
    //FAQ Pages Methods
    @AuraEnabled
    public static List<PP_FAQ_QA__c> lstFAQ(String strCategory){
        List<PP_FAQ_QA__c> lstFaqs = New List<PP_FAQ_QA__c>();
        for(PP_FAQ_QA__c objFAQ : [SELECT Id,PP_FAQ_SubCategory__c, PP_Answer__c, PP_Question__c, SINumber__c, PP_FAQ_SubCategory__r.PP_Subcategory_Type__c 
                                   FROM PP_FAQ_QA__c WHERE PP_FAQ_SubCategory__r.PP_Subcategory_Type__c =:strCategory 
                                   AND PP_FAQ_SubCategory__r.PP_FAQ_Category__r.PP_Category_Type__c = 'Payroll' ORDER BY SINumber__c ASC]){
            lstFaqs.add(objFAQ);    
        } 
        return lstFaqs;
    }
    
    
    @AuraEnabled
    public static List<PP_FAQ_SubCategory__c> lstSubCategoryFaqs(String strFAQType){
        List<PP_FAQ_SubCategory__c> lstSubCategoryFaqs = New List<PP_FAQ_SubCategory__c>();
        for(PP_FAQ_SubCategory__c objFAQ : [SELECT Id,Description__c, PP_FAQ_Category__c, PP_Subcategory_Type__c 
                                            FROM PP_FAQ_SubCategory__c WHERE PP_Subcategory_Type__c =:strFAQType
                                            AND PP_FAQ_Category__r.PP_Category_Type__c= 'Payroll']){
                lstSubCategoryFaqs.add(objFAQ); 
        }
        if(lstSubCategoryFaqs.size()>0){
            for(PP_FAQ_SubCategory__c objFAQ : [SELECT Id,Description__c, PP_FAQ_Category__c, PP_Subcategory_Type__c 
                                                FROM PP_FAQ_SubCategory__c WHERE PP_FAQ_Category__r.PP_Category_Type__c= 'Payroll']){
                if(objFAQ.PP_Subcategory_Type__c != strFAQType){
                    lstSubCategoryFaqs.add(objFAQ); 
                } 
            }
        }
        return lstSubCategoryFaqs;
    }
    
    
    @AuraEnabled
    public static PP_FAQ_SubCategory__c FAQDescriptions(String strCategory){
        PP_FAQ_SubCategory__c objFAQ = [SELECT Description__c
                                        FROM PP_FAQ_SubCategory__c WHERE PP_Subcategory_Type__c =:strCategory 
                                        AND PP_FAQ_Category__r.PP_Category_Type__c = 'Payroll' LIMIT 1];
        return objFAQ;
    }
    
   @AuraEnabled 
     public static List<Wrapper_PaydateResults> lstPay(String strSelectedYear){
        system.debug('==lstPay=='+strSelectedYear.substring(1, 5));
        User userObj = [Select Id, Name, Email from User where Id =: UserInfo.getUserId()];
        accObj = [Select Id, Name, OwnerId, PersonEmail, PP_Employee_Number__c, PP_Hiring_Date__c from Account
                    where OwnerId =: userObj.Id LIMIT 1];
        String HireDate = (accObj.PP_Hiring_Date__c).year() +'-' + (accObj.PP_Hiring_Date__c).month() + '-' + (accObj.PP_Hiring_Date__c).day();
        String EndDate = '9999-12-31';
        String EmployeeNumber = accObj.PP_Employee_Number__c;
        String FromDate =String.valueOf(HireDate);
        String ToDate= String.valueOf(EndDate);
        HttpResponse resp;
        
        Map<String,String> mapKeyMonthName = New Map<String,String>();
         mapKeyMonthName.put('01','January');mapKeyMonthName.put('02','February');
         mapKeyMonthName.put('03','March');mapKeyMonthName.put('04','April');
         mapKeyMonthName.put('05','May');mapKeyMonthName.put('06','June');
         mapKeyMonthName.put('07','July');mapKeyMonthName.put('08','August');
         mapKeyMonthName.put('09','September');mapKeyMonthName.put('10','October');
         mapKeyMonthName.put('11','November');mapKeyMonthName.put('12','December');
         resp = PP_PayStub_API_Controller.makeCallout(EmployeeNumber, FromDate, ToDate);
        
         String jsonString = resp.getBody();
         System.debug('-------------strSelectedYear--->'+jsonString);
         JSONtoApex obj = JSONtoApex.parse(jsonString);
        Set<String> setRemoveDuplicate = New Set<String>();
        List<String> lstSortMonth = lstSortMonth();
        List<Wrapper_PaydateResults> lstResults= New List<Wrapper_PaydateResults >();
        Wrapper_PaydateResults p = new Wrapper_PaydateResults();
         for(String str : lstSortMonth){
             for(integer i=1; i<obj.BAPI_GET_PAYROLL_RESULT_LIST.tables.RESULTS.row.size(); i++){
                 String strDate = obj.BAPI_GET_PAYROLL_RESULT_LIST.tables.RESULTS.row[i].PAYDATE;
                 String strFinalDate = strDate.substring(5, 7)+'/' + strDate.substring(8, 10) + '/'+ strDate.substring(0, 4);
                 if(strDate.substring(0, 4) == strSelectedYear.substring(1, 5)){
                     if(!setRemoveDuplicate.contains(strDate.substring(5, 7)) && str == strDate.substring(5, 7)){
                         setRemoveDuplicate.add(strDate.substring(5, 7));
                         system.debug('===strFinalDate='+strFinalDate);
                            Date dt =  Date.parse(strFinalDate);  
                            Integer dy = dt.day();
                            String d;
                            if(dy<10){d='0'+String.valueOf(dy);} else {d=String.valueOf(dy);}
                            
                            Integer mn = dt.month();
                            String m;
                            if(mn<10){m='0'+String.valueOf(mn);} else {m=String.valueOf(mn);}
                            
                            Integer yr = dt.year();
                            
                            String strParsePayDate = m +'/'+ d +'/'+String.valueOf(yr);

                        lstResults.add(p.getPaydateResults(EmployeeNumber, obj.BAPI_GET_PAYROLL_RESULT_LIST.tables.RESULTS.row[i].SEQUENCENUMBER,
                        strParsePayDate,
                        mapKeyMonthName.get(strDate.substring(5, 7))));
                     }
                 }
             }
         }
         system.debug('====lstResults[]===='+lstResults);
        return lstResults;  
    }
    
    @AuraEnabled
    public static List<Wrapper_PayrollResults> lstPay1(String seq, String pdate){ 
        Wrapper_PayrollResults p = new Wrapper_PayrollResults();
        List<Wrapper_PayrollResults> lstResults1= new List<Wrapper_PayrollResults>();
        User userObj = [Select Id, Name, Email from User where Id =: UserInfo.getUserId()];
        accObj = [Select Id, Name, OwnerId, PersonEmail, PP_Employee_Number__c, PP_Hiring_Date__c from Account
                    where OwnerId =: userObj.Id LIMIT 1];
        String HireDate = (accObj.PP_Hiring_Date__c).year() +'-' + (accObj.PP_Hiring_Date__c).month() + '-' + (accObj.PP_Hiring_Date__c).day();
        String EndDate = '9999-12-31';
    
        String EmployeeNumber = accObj.PP_Employee_Number__c;
        String FromDate =String.valueOf(HireDate);
        String ToDate= String.valueOf(EndDate);
        lstResults1.add(p.getPayrollResults(EmployeeNumber, seq, pdate));
        system.debug('===========Jan======'+lstResults1);
        return lstResults1;   

    }
    
   public class Wrapper_PaydateResults{
        @AuraEnabled
        public String SequenceNumber {get;set;}
        @AuraEnabled
        public String PayDate {get;set;}
        @AuraEnabled
        public String strMonthName {get;set;}
        Wrapper_PaydateResults pr;
        
        public Wrapper_PaydateResults getPaydateResults(String EmployeeNumber, String seq, String pdate, String strMonthName){
        
            pr = new Wrapper_PaydateResults();
            pr.SequenceNumber = seq;
            pr.PayDate = pdate;
            pr.strMonthName = strMonthName; 
            return pr;
       }
    }
     public class Wrapper_PayrollResults{
        @AuraEnabled
        public String SequenceNumber {get;set;}
        @AuraEnabled
        public String PayDate {get;set;}
        @AuraEnabled
        public List<Wrapper_PayrollDetailResults> lstDetails{get;set;}
        @AuraEnabled
        public String Tax {get;set;}
        @AuraEnabled
        public String PaidEarnings{get;set;}
        @AuraEnabled
        public String Deductions{get;set;}
        @AuraEnabled
        public String Netpay{get;set;}
        @AuraEnabled
        public String CURDirectDep{get;set;}
        @AuraEnabled
        public String YTDTax {get;set;}
        @AuraEnabled
        public String YTDPaidEarnings{get;set;}
        @AuraEnabled
        public String YTDDeductions{get;set;}
        @AuraEnabled
        public String YTDNetpay{get;set;}
        @AuraEnabled
        public String YTDDirectDep{get;set;}
        @AuraEnabled
        public String DirectDep{get;set;}
        @AuraEnabled
        public String Check {get; set;}
        List<Wrapper_PayrollDetailResults> lstPayDetails;
        Wrapper_PayrollDetailResults objPayDetails;
        Wrapper_PayrollResults pr;
       
       
        public Wrapper_PayrollResults getPayrollResults(String EmployeeNumber, String seq, String pdate){
            pr = new Wrapper_PayrollResults();
            lstDetails = new List<Wrapper_PayrollDetailResults>();
            pr.SequenceNumber = seq;
            pr.PayDate = pdate;
            
            lstDetails = invokePayStubAPI_getSalaryDetails(EmployeeNumber, seq);
    
         
            System.debug('-------------lstDetails123--->'+lstDetails);


         if(lstDetails[0].DDValue != null && lstDetails[0].DirectDep == 'DirectDep'){ //
                pr.DirectDep = lstDetails[0].DDValue;
                pr.Check =String.valueOf('0');
            }
            else if(lstDetails[0].DDValue != null && lstDetails[0].DirectDep == 'Check'){
                pr.DirectDep =String.valueOf('0');
                pr.Check = lstDetails[0].DDValue;
            }
            else{
                pr.DirectDep = String.valueOf('0');
                pr.Check =String.valueOf('0');
            }
            
            
            pr.PaidEarnings = lstDetails[2].PaidEarnings;
            pr.Tax = lstDetails[2].Tax ;
            pr.Deductions = lstDetails[2].Deductions;
            pr.NetPay = lstDetails[2].Netpay;
            if(lstDetails[1].DDValue != null){  //
                pr.CURDirectDep = lstDetails[1].DDValue;
            }
            else{
                pr.CURDirectDep = String.valueOf('0');
            }
            

 
            if(lstDetails[3].PaidEarnings != null){
                pr.YTDPaidEarnings = lstDetails[3].PaidEarnings;
            }
            if(lstDetails[3].Tax != null){
                pr.YTDTax = lstDetails[3].Tax ;
            }
            if(lstDetails[3].Deductions != null){
                pr.YTDDeductions = lstDetails[3].Deductions;
            }
            if(lstDetails[3].Netpay != null){
                pr.YTDNetPay = lstDetails[3].Netpay;
            }
            System.debug('-------------lstDetails[3].DirectDep===>'+lstDetails[3].DirectDep);
            if(lstDetails[2].DDValue != null){ //
                pr.YTDDirectDep = lstDetails[2].DDValue ;
            }
            else{
                pr.YTDDirectDep = String.valueOf('0');
            }
            
            return pr;
        }  
        
        public List<Wrapper_PayrollDetailResults> invokePayStubAPI_getSalaryDetails(String EmployeeNumber, String SeqNumber){
            HttpResponse resp;
            System.debug('-------------SeqNumber--->'+SeqNumber);
            resp = PP_PayStub_API_Controller.makeCalloutSequenceNumber(EmployeeNumber, SeqNumber);
            
             String jsonString = resp.getBody();
             
            JSONtoApexPaySlipParser obj = JSONtoApexPaySlipParser.parse(jsonString);
            System.debug('-------------Second Callout--->'+obj);
            
            Wrapper_PayrollDetailResults p = new Wrapper_PayrollDetailResults();
            lstPayDetails = new List<Wrapper_PayrollDetailResults>();
            String DD;
            if(obj.BAPI_GET_PAYSLIP.tables.PAYSLIP.row != null){ 
               for(integer i=15; i<19; i++){
                    System.debug('-------------DDValue--->'+DD);
                    objPayDetails = p.getPayrollDetailResults(i,obj.BAPI_GET_PAYSLIP.tables.PAYSLIP.row[i].TEXT_COL,DD);
                    System.debug('-------------objPayDetails--->'+objPayDetails);
                    DD = objPayDetails.DDValue;
                    lstPayDetails.add(objPayDetails);
                     
               }
            }    
            return lstPayDetails;
        }

    }

    public class Wrapper_PayrollDetailResults{
        @AuraEnabled
        public String Tax;
        public String PaidEarnings;
        public String Deductions;
        public String Netpay;
        public String DirectDep;
        public String DirectDep1;
        public String DDValue;
        public integer flag;

        Wrapper_PayrollDetailResults pr;

        public Wrapper_PayrollDetailResults getPayrollDetailResults(Integer row, String textCol, String DirectDepValue){
            pr = new Wrapper_PayrollDetailResults();
            String test = textCol.deleteWhitespace();
            List<String> parseData = test.split('\\|');
            System.debug('----------->------>'+parseData);
            
            if(row == 15){
                pr.PaidEarnings = parseData[2];
                pr.Tax = parseData[3];
                pr.Deductions = parseData[4];
                pr.Netpay = parseData[5];
                if(parseData.size()>6){
                    pr.DirectDep = parseData[6];
                    pr.DDValue = parseData[7];
                }
            }
            if(row == 16){
                pr.PaidEarnings = '0';
                pr.Tax = '0';
                pr.Deductions = '0';
                pr.Netpay = '0';
                if(DirectDepValue != null){
                    pr.DirectDep = DirectDepValue;
                }    
                if(parseData.size()>2){
                    pr.DDValue = parseData[3];
                }    
            }
            if(row == 17){
                pr.PaidEarnings = parseData[2];
                pr.Tax = parseData[3];
                pr.Deductions = parseData[4];
                pr.Netpay = parseData[5];
                if(DirectDepValue != null){
                    pr.DirectDep = DirectDepValue;
                }    
                if(parseData.size()>6){
                    pr.DDValue = parseData[7];
                }
            }        
            if(row == 18){
                pr.PaidEarnings = parseData[2];
                pr.Tax = parseData[3];
                pr.Deductions = parseData[4];
                pr.Netpay = parseData[5];
                if(DirectDepValue != null){
                    pr.DirectDep = DirectDepValue;
                }    
            }
           return pr;
        }
    }
}