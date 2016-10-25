/***------------------------------------------------------------------------------------------------------------***
* File Name         :  PP_PayslipJsontoApex 
* Description       :  Json to Apex for Multiple Payslip in a year for an Employee(My Pay Summary - People Portal)
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***-------------------------------------------------------------------------------------------------------------***/

public class PP_PayslipJsontoApex{
    public cls_PAY_SUMMARY PAY_SUMMARY;
    public class cls_PAY_SUMMARY {
        public cls_BAPI_GET_PAYSLIP[] BAPI_GET_PAYSLIP;
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
        public String id2;  //0
        public String FORMAT_COL;   ///
        public String TEXT_COL; //------------------------------------------------------------------------------------------------------------------------
    }
    public static PP_PayslipJsontoApex parse(String json){
        return (PP_PayslipJsontoApex) System.JSON.deserialize(json, PP_PayslipJsontoApex.class);
    }
}

/*
public class PP_PayslipJsontoApex{
    public cls_PAY_SUMMARY PAY_SUMMARY;
    
    public class cls_PAY_SUMMARY {
        public cls_BAPI_GET_PAYSLIP[] BAPI_GET_PAYSLIP;
    }
    public class cls_BAPI_GET_PAYSLIP {
        public String id1; 
        //public cls_import import1;
      //  public cls_export export1;
        public cls_tables tables;
    }
    public class cls_tables {
        public cls_PAYSLIP PAYSLIP;
    }
    public class cls_PAYSLIP {
        public cls_row[] row;
    }
    public class cls_row {
        public String id3;  //0
        public String FORMAT_COL;   ///
        public String TEXT_COL; //------------------------------------------------------------------------------------------------------------------------
    }
    public static PP_PayslipJsontoApex parse(String json){
        return (PP_PayslipJsontoApex) System.JSON.deserialize(json, PP_PayslipJsontoApex.class);
    }
}
*/