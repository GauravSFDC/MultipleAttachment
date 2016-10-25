/***-----------------------------------------------------------------------------***
* File Name         :  PP_MyPaySlip_Cntrl 
* Description       :  Custom Controller for My Pay Summary - People Portal
* Author            :  Janani Ramakrishnan - Cognizant Technology Solutions
* Modification Log  :   
***-----------------------------------------------------------------------------***/

public class PP_MyPaySlip_Cntrl {
    public List<Wrapper_PayrollResults> lstResults{get; set;}
    public List<Wrapper_PayrollDetailResults> lstPayDetails{get; set;}
    public String EmployeeNumber{get;set;}
    public String SeqNumber{get;set;}
    public Static Account accObj{get;set;}
    public Static Wrapper_PayrollResults wpr{get;set;}
    public Static List<Wrapper_PayrollResults> lstWPR {get;set;}
    public Static List<Wrapper_PayrollResults> lstFinalPayDetails {get;set;}
    public String emailMsg;
    public static List<Wrapper_PayrollResults> lstResults1{get; set;}
    public static List<Wrapper_PayrollResults> lstResults2{get; set;}

    public PP_MyPaySlip_Cntrl(){
        lstFinalPayDetails = new List<Wrapper_PayrollResults>();
        lstResults1= new List<Wrapper_PayrollResults>();
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
    public static List<Wrapper_PayrollResults> lstPay(String strSelectedYear){ //,String strName
        String SelectedYear = strSelectedYear.subString(1,5);
        lstResults2= new List<Wrapper_PayrollResults>();
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
        for(integer i=1;i<=12;i++){
            date myDate = date.newInstance(2016, i, 1);
            mapKeyMonthName.put(String.valueOf(i), String.valueOf(myDate.month()));
        }

        List<String> lstSortDate = New List<String>();
        for(integer i=31;i>=1;i--){
            date myDate = date.newInstance(2016, 1, i);
            lstSortDate.add(String.valueOf(myDate.day()));
        }

        lstResults1 = invokePAYBAPI(SelectedYear, accObj.PP_Employee_Number__c);
        
        Integer lstSize = lstResults1.size();
        Map<String,String> mapKeyMonthName1 = New Map<String,String>();
        mapKeyMonthName1.put('01','January');mapKeyMonthName1.put('02','February');
        mapKeyMonthName1.put('03','March');mapKeyMonthName1.put('04','April');
        mapKeyMonthName1.put('05','May');mapKeyMonthName1.put('06','June');
        mapKeyMonthName1.put('07','July');mapKeyMonthName1.put('08','August');
        mapKeyMonthName1.put('09','September');mapKeyMonthName1.put('10','October');
        mapKeyMonthName1.put('11','November');mapKeyMonthName1.put('12','December');
        set<string> setMonth = new set<string>();
        
       // Integer lstSize = lstResults1.size();
        //for(integer i=0,j=lstSize-1; j>=0; j--){
           // if(!setMonth.contains(lstResults1[j].PayDate.substring(0, 2))){
            //    setMonth.add(lstResults1[j].PayDate.substring(0, 2));
           //     lstResults1[j].strMonthName =mapKeyMonthName1.get(lstResults1[j].PayDate.substring(0, 2));
          //  }
          //  else{
          //      lstResults1[j].strMonthName = null;
          //  }
           // lstResults2.add(lstResults1[j]);
           // lstResultsTemp.add(lstResults1[j]);
          //  i++;
       // }
       // system.debug('=lstResults2==='+lstResults2);
       // return lstResults2;   
  //  }
        for(integer i=0,j=lstSize-1; j>=0; j--){
            if(!setMonth.contains(lstResults1[j].PayDate.substring(0, 2))){
                setMonth.add(lstResults1[j].PayDate.substring(0, 2));
                lstResults1[j].strMonthName =mapKeyMonthName1.get(lstResults1[j].PayDate.substring(0, 2));
            }
            else{
                lstResults1[j].strMonthName = null;
            }
            lstResults2.add(lstResults1[j]);
            i++;
             
        }
        system.debug('==lstResults2==='+lstResults2);
        return lstResults2;   
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
    public static List<Wrapper_PayrollResults> invokePAYBAPI(String selectedYear, String EmployeeNumber){
//         try{  
            String requestedStartDate;
            String requestedEndDate;
            List<Wrapper_PayrollResults> templstWPR;
            lstWPR = new List<Wrapper_PayrollResults>();

            // The below if condition block will execute only once when we invoke the request for the very first time
            // Pass the list of arguments to the wrapper class method to invoke the callout.
            // Store the list of pay details in lstWPR variable
            // For example, 1st time, the current year 2016 will be processed and all the weekly / monthly pay details 
            // will be stored in the lstWPR variable
            // Sequently, if the user selects 2015/2014/... next time, the if condition will be failed and go to else block
             
            if(lstWPR.size() == 0 || lstWPR == null){
                requestedStartDate = selectedYear+'-01-01';
                requestedEndDate = selectedYear+'-12-31';
                templstWPR = new List<Wrapper_PayrollResults>();
                wpr = new Wrapper_PayrollResults();

                for(Wrapper_PayrollResults wp : wpr.getPayrollResults(EmployeeNumber, requestedStartDate, requestedEndDate)){
                    lstWPR.add(wp);
                }
            }
            else{
            // The system will enters this block when the user select the year from current selected year to different year
            // The Boolean flag is set to check when the user choose the same year multiple times
            // Example: Current year is 2016, when the user navigates to 2015, flag = true;
            //                                when the user navigates to 2014, flag = true;
            //                                when the user navigates to 2013, flag = true;
            //                                when the user navigates to 2015, flag = false; 
            // Since the user already visited the year 2015, the data's are already available in the list, no need to invoke the call out. 
            
                Boolean flag = true;
                for(integer i=0; i<lstWPR.size(); i++){
                    if(lstWPR[i].PAYDATE.contains(selectedYear)){
                        flag =false;
                        templstWPR = new List<Wrapper_PayrollResults>();
                        break;
                    }
                }
                
            // when the flag is set to true, assign the start date and end date as per the new selected year 
            // Pass the list of arguments to the wrapper class method to invoke the callout.
            
                if(flag == true){
                    requestedStartDate = selectedYear+'-01-01';
                    requestedEndDate = selectedYear+'-12-31';
                    templstWPR = new List<Wrapper_PayrollResults>();
                    wpr = new Wrapper_PayrollResults();
                    
                    templstWPR = wpr.getPayrollResults(accObj.PP_Employee_Number__c, requestedStartDate, requestedEndDate);
                }
            
            // To consolidate the data, store all the results in the lstWPR variable
            // The lstWPR variable contains the details of all weekly / monthly Paydata for all the selected years
              
                if(templstWPR.size() > 0){
                    for(Wrapper_PayrollResults w : templstWPR){
                        lstWPR.add(w);
                    }
                }
            }
    
            // For better optimized results, display only the results of the selected year
            // The lstWPR variable contains the whole data, the below logic fetches the data based on the selected year
            // The data's will be stored in the lstFinalPayDetails variable and displayed on the VF page
            
            lstFinalPayDetails = new List<Wrapper_PayrollResults>();
            for(Wrapper_PayrollResults wp : lstWPR){
                if(wp.PAYDATE.contains(selectedYear)){
                    lstFinalPayDetails.add(wp);
                }
            }
//         }
         
         // An exception will be thrown when there is no payroll available for the selected year
            
//         catch(Exception ex){
  //           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There is no payroll for the selected year!!'));
    //     }
         return lstFinalPayDetails;   
             
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
        @AuraEnabled
        public String totalDirectDep {get; set;}
        @AuraEnabled
        public String strMonthName {get;set;}
        public List<Wrapper_PayrollDetailResults> lstPayDetails;
        public List<Wrapper_PayrollResults> lstResults{get; set;}
        Wrapper_PayrollDetailResults objPayDetails;
        Wrapper_PayrollResults pr;
       
        public List<Wrapper_PayrollResults> getPayrollResults(String EmployeeNumber, String HireDate, String Enddate){
            lstDetails = new List<Wrapper_PayrollDetailResults>();
            lstResults = new List<Wrapper_PayrollResults>();
            Map<String, List<Wrapper_PayrollDetailResults>> mapPayFullDetails = new Map<String, List<Wrapper_PayrollDetailResults>>();
            Wrapper_PayrollDetailResults payDatafromList = new Wrapper_PayrollDetailResults();
            
            mapPayFullDetails = invokePayStubAPI_getSalaryDetails(EmployeeNumber,Hiredate,Enddate);
            
            Set<String> setKeys = new Set<String>();
            List<String> lstKeys = new List<String>();
            
        
        
         // Fetch the set of keys from the map variable
         // Iterate the set variable to copy all the keys into a list variable 
            
            setkeys = mapPayFullDetails.keySet();
            
            for(String s : setkeys){
                lstKeys.add(s);
            }
            
         // Iterate the list of keys and fetch the corresponsing pay details associated to each key
         // Store the paydetails value to the respective local variable
         // As the lstDetails variable contains the data in the matrix format, we can assignt the values directly to the local variable
         // The below logic assign the values from 2nd wrapper class to the local variables of the 1st wrapper class
         // Each payDetails are assigned to a structured local variable and added to a lst variable "lstDetails"
         // Returns the list variable to the main class method
            

             Map<String,String> mapKeyMonthName = New Map<String,String>();
             mapKeyMonthName.put('01','January');mapKeyMonthName.put('02','February');
             mapKeyMonthName.put('03','March');mapKeyMonthName.put('04','April');
             mapKeyMonthName.put('05','May');mapKeyMonthName.put('06','June');
             mapKeyMonthName.put('07','July');mapKeyMonthName.put('08','August');
             mapKeyMonthName.put('09','September');mapKeyMonthName.put('10','October');
             mapKeyMonthName.put('11','November');mapKeyMonthName.put('12','December');
            set<string> setMonth = new set<string>();

            for(integer j=0; j<mapPayFullDetails.size(); j++){
                pr = new Wrapper_PayrollResults();
                
                pr.PayDate = lstKeys[j];
//                if(!setMonth.contains(pr.PayDate.substring(0, 2))){
  //                  setMonth.add(pr.PayDate.substring(0, 2));
                    pr.strMonthName =mapKeyMonthName.get(pr.PayDate.substring(0, 2));
    //            }
        
                lstDetails = mapPayFullDetails.get(lstKeys[j]);
                pr.SequenceNumber = lstDetails[0].SequenceNumber;
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
                if(lstDetails[2].DDValue != null){ //
                    pr.YTDDirectDep = lstDetails[2].DDValue ;
                }
                else{
                    pr.YTDDirectDep = String.valueOf('0');
                }      
                pr.totalDirectDep = pr.DirectDep + pr.CURDirectDep + pr.YTDDirectDep;
                 lstResults.add(pr);
            }
           return lstResults; 
        }

        public Map<String, List<Wrapper_PayrollDetailResults>> invokePayStubAPI_getSalaryDetails(String EmployeeNumber, String StartDate, String EndDate){
            HttpResponse resp;
            PP_PayslipJsontoApex obj;
            PP_PayslipSingleJsontoApex objSingle;
            Wrapper_PayrollDetailResults p = new Wrapper_PayrollDetailResults();
            String DD;
            String PayDate;
            Map<String, List<Wrapper_PayrollDetailResults>> mapPayDateDetails = new Map<String, List<Wrapper_PayrollDetailResults>>();
            String jsonString;
            if(!Test.isRunningTest()){
                resp = PP_PaySlip_API_Controller.makeCallout(EmployeeNumber, StartDate, EndDate);
                jsonString = resp.getBody();
            }
            else{
                PP_MyPaySlip_API_Controller_MockResponse mr= new PP_MyPaySlip_API_Controller_MockResponse();
                 jsonString = mr.mockResponse();
            }
            system.debug('!!!!123!!!!'+resp);
            system.debug('!!!!janani!!!!'+jsonString);
            String updatedjson = jsonString.replace('import', 'import1');
            
         // If the callout response contains single payroll information, then count will be 1.
         // If the count is set to 1, the else block will get execute and parse the data
         // if the callout response contians more than one pay roll, if block will execute and iterate the results
         // The count value is calculated based on the SEQUENCENUMBER recieved in the response
         // The reponse holds the data in multiple rows
         // Example: Row Number 4 contains Pay Data information
         //          Row Number 15 contains Pay details Header information and Direct Deposit / Check values
         //          Row Number 16 contains Direct Deposit / Check values
         //          Row Number 17 contains the values of paid earnings, deductions, taxes, netpay for "CUR"
         //          Row Number 18 contains the values of paid earnings, deductions, taxes, netpay for "YTD"
         // The results are iterated and stored in the map variable Map<String, List<Wrapper_PayrollDetailResults>>
            
            Integer count = jsonString.countMatches('SEQUENCENUMBER');
            if(count > 1){
                obj = PP_PayslipJsontoApex.parse(updatedjson);
                for(integer j=0; j<obj.PAY_SUMMARY.BAPI_GET_PAYSLIP.size(); j++){ 
                    String sequenceNo = obj.PAY_SUMMARY.BAPI_GET_PAYSLIP[j].import1.SEQUENCENUMBER;
                    lstPayDetails = new List<Wrapper_PayrollDetailResults>();
                    for(integer i=4; (i>3 && i<19); i++){
                        if(i==4){
                            String pdateTest = (obj.PAY_SUMMARY.BAPI_GET_PAYSLIP[j].tables.PAYSLIP.row[i].TEXT_COL).deleteWhitespace();
                            List<String> splitlstPayDate = pdateTest.split('\\|');
                            String splitPayDate = splitlstpayDate[3];
                            List<String> splitPayDate1 = splitPayDate.split('\\:');
                            PayDate = splitPayDate1[1];
                        }
                        else 
                        if(i>14 && i <19){
                            objPayDetails = p.getPayrollDetailResults(i,obj.PAY_SUMMARY.BAPI_GET_PAYSLIP[j].tables.PAYSLIP.row[i].TEXT_COL,DD,sequenceNo);
                            DD = objPayDetails.DDValue;
                            lstPayDetails.add(objPayDetails);
                        }
                    }    
                    mapPayDateDetails.put(PayDate,lstPayDetails);
                }
            }
            else{
                objSingle = PP_PayslipSingleJsontoApex.parse(updatedjson);
                String sequenceNo;
                    try{
                        sequenceNo = objSingle.PAY_SUMMARY.BAPI_GET_PAYSLIP.import1.SEQUENCENUMBER;
                        lstPayDetails = new List<Wrapper_PayrollDetailResults>();
                        for(integer i=4; (i>3 && i<19); i++){
                            if(i==4){
                                String pdateTest = (objSingle.PAY_SUMMARY.BAPI_GET_PAYSLIP.tables.PAYSLIP.row[i].TEXT_COL).deleteWhitespace();
                                List<String> splitlstPayDate = pdateTest.split('\\|');
                                String splitPayDate = splitlstpayDate[3];
                                List<String> splitPayDate1 = splitPayDate.split('\\:');
                                PayDate = splitPayDate1[1];
                            }
                            else 
                            if(i>14 && i <19){
                                objPayDetails = p.getPayrollDetailResults(i,objSingle.PAY_SUMMARY.BAPI_GET_PAYSLIP.tables.PAYSLIP.row[i].TEXT_COL,DD,sequenceNo);
                                DD = objPayDetails.DDValue;
                                lstPayDetails.add(objPayDetails);
                            }
                        }    
                        mapPayDateDetails.put(PayDate,lstPayDetails);
                    }
                    catch(Exception ex){
                    }
                }
                                
            return mapPayDateDetails;
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
        public String SequenceNumber{get; set;}


        Wrapper_PayrollDetailResults pr;

        public Wrapper_PayrollDetailResults getPayrollDetailResults(Integer row, String textCol, String DirectDepValue, String SeqNo){
            pr = new Wrapper_PayrollDetailResults();
            String test = textCol.deleteWhitespace();
            List<String> parseData = test.split('\\|');
            pr.SequenceNumber = SeqNo;
            
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