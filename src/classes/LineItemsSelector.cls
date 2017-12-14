/**
 * Created by arjun.mohan on 9/28/2017.
 */

public  class LineItemsSelector {

    public static List<Apttus_Config2__LineItem__c> getLineItemsForCartId(Id cartId,String productType)
    {
        return [Select Id,Program__c,Apttus_Config2__AttributeValueId__r.APTS_DestinationCode__c,Apttus_Config2__AttributeValueId__r.APTS_Beginner__c
        from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:cartId
        and Apttus_Config2__OptionId__r.Apttus_Config2__ProductType__c=:productType
        and APTS_HasStartDateConfigured__c=FALSE ];
    }

    public static List<Apttus_Config2__LineItem__c> getLineItemsForselectedConfigId(List<Id> confiigIdset,List<Decimal> lineNumberLisr)
    {
        return [Select Id,Program__c,Apttus_Config2__Quantity__c,Apttus_Config2__EndDate__c,Apttus_Config2__StartDate__c
        from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c in :confiigIdset and Apttus_Config2__LineNumber__c in :lineNumberLisr];

    }

}