/**************************************************************************************
Apex Class Name    : AccountsSelector
Version            : 1.0
Created Date       : July 16 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * shravan.boddula                 07/12/2017              Original Version
*******************************************************************************/
public class AccountsSelector {
    public static account getdestinationAccount(account objAccount){
        return  [select id,FirstName,region__c,PersonMailingStreet,HasBooking__c,PersonMailingPostalCode,personmailingcity,personmailingstate,LastName,TritonId__c,PersonHomePhone,PersonMobilePhone,PersonOtherPhone,DOB__c,PersonEmail,Email2__c from account where id = :objAccount.id];
    }
    public static List<Account> getAllAccountOnId(List<Id> accIDList) {
        return [
                select id, FirstName, LastName, PersonMailingCity, PersonMailingCountry,PersonMailingPostalCode,
                        PersonMailingStreet,PersonHomePhone,PersonMobilePhone,PersonOtherPhone,
                         DOB__c, PersonEmail, Email2__c,  Market__c, Language__c, Age__c, 
                        Region__c,HasBooking__c, BookingDate__c,TritonId__c
                from Account
                where Id IN :accIDList
        ];
    }

    public static Account getAccountOnId(Id accountId) {
        return [
                select id, FirstName,LastName,PersonMailingCity,PersonMailingCountry,PersonMailingPostalCode,
                        PersonMailingStreet, PersonEmail,Email2__c,PersonHomePhone,PersonMobilePhone,
                        PersonOtherPhone,DOB__c,Market__c,Region__c,
                        HasBooking__c,BookingDate__c,TritonId__c
                from Account
                where Id = :accountId
                limit 1
        ];
    }
    
    public static List<Account> getallAccountChilds_Optm(Set<Id> accountId) {

    List<Account> accountChildRecordsList=[select id,(select id,name from contacts where accountId in : accountId),(SELECT Id,StageName,Name,AccountId,CloseDate from opportunities where IsDeleted = false and accountId in : accountId) from account where id in : accountId];
    
    System.debug('Query results'+JSON.serialize(accountChildRecordsList));return accountChildRecordsList;
}
 
     public static Account getAccountonOpportunity(Opportunity opportunityRecord){
        return [Select PersonContactId From Account Where Id = :opportunityRecord.AccountId];
    }

   
}