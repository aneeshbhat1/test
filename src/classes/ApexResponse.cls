/**
 * Created by aditi.sharma on 11/24/2017.
 */

public class ApexResponse {
    @AuraEnabled
    public string ResponseCode{get; set;}
    @AuraEnabled
    public string ErrorMessage{get; set;}
    @AuraEnabled
    public Map<String,String> Result{get; set;}

}