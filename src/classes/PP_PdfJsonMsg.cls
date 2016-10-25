/***------------------------------------------------------------------------------------------------------------***
* File Name         :  PP_PdfJsonMsg 
* Description       :  Json to Apex Controller for Sending Email functionality (My Pay Summary - People Portal)
* Author            :  Janani Ramakrishnan - Cognizant Technology Solution
* Modification Log  :   
***-------------------------------------------------------------------------------------------------------------***/

public class PP_PdfJsonMsg{
    public String ERRORDESCRIPTION; 
    public static PP_PdfJsonMsg parse(String json){
        return (PP_PdfJsonMsg) System.JSON.deserialize(json, PP_PdfJsonMsg.class);
    }
}