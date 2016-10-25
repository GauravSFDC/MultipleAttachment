/***------------------------------------------------------------------------------------------------------------***
* File Name         :  PP_PayslipSingleJSONtoApex 
* Description       :  Json to Apex for Single Payslip in a year for an Employee(My Pay Summary - People Portal)
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***-------------------------------------------------------------------------------------------------------------***/

public class PP_PayslipSingleJSONtoApex{
        public cls_PAY_SUMMARY PAY_SUMMARY;
        public class cls_PAY_SUMMARY {
            public cls_BAPI_GET_PAYSLIP BAPI_GET_PAYSLIP;
        }
        public class cls_BAPI_GET_PAYSLIP {
            public String id1;  //0
            public cls_import1 import1;
            public cls_tables tables;
        }
        public class cls_import1 {
            public String EMPLOYEENUMBER;   //00042564
            public String SEQUENCENUMBER;   //00451
        }
        public class cls_tables {
            public cls_PAYSLIP PAYSLIP;
        }
        public class cls_PAYSLIP {
            public cls_row[] row;
        }
        public class cls_row {
            public String id1;  //0
            public String FORMAT_COL;   ///
            public String TEXT_COL; //------------------------------------------------------------------------------------------------------------------------
        }
        public static PP_PayslipSingleJSONtoApex parse(String json){
            return (PP_PayslipSingleJSONtoApex) System.JSON.deserialize(json, PP_PayslipSingleJSONtoApex.class);
        }
    }