/**************************************************************************************
Apex Class Name    : ContactsSelector
Version            : 1.0
Created Date       : July 16 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * shravan.boddula                 07/12/2017              Original Version
*******************************************************************************/
public class CustomSettingsSelector {
    public static Map<string, MergeRuleConfig__c> getMergeRuleConfig(){
        Map<string, MergeRuleConfig__c> returnMergeRuleConfig = new  Map<string, MergeRuleConfig__c>([ select Decision__c,Street__c,TritonId__c,name,City__c, DOB__c, FirstName__c, HasBooking__c, LastName__c, MobilePhone__c,OtherPhone__c,Phone__c, Region__c, PostalCode__c,Email__c,Email2__c
        from MergeRuleConfig__c]);
        return returnMergeRuleConfig;

    }
}