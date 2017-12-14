/**
 * Created by arjun.mohan on 9/28/2017.
 */

public  class ProductAttributevaluesSelector {

    public  static Map<Id, Apttus_Config2__ProductAttributeValue__c> getProductAttributeValuesById(Id cartId)
    {
        Map<Id, Apttus_Config2__ProductAttributeValue__c> productAttributeMap = new Map<Id, Apttus_Config2__ProductAttributeValue__c> (
            [select Id,APTS_Beginner__c, APTS_DestinationCode__c, APTS_End_Date__c, Quantity__c, APTS_Start_Date__c, Apttus_Config2__LineItemId__r.Apttus_Config2__OptionId__r.Apttus_Config2__ProductType__c  
             from Apttus_Config2__ProductAttributeValue__c
             where Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c = : cartId]);
        return productAttributeMap;
    }
}