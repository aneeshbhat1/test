/**************************************************************************************
Apex Class Name    : ProductAttributeValueHelper
Version            : 1.0
Created Date       : September 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/20/2017              Original Version
*******************************************************************************/

public  class ProductAttributeValueHelper {

    //In this method we will update values based on destination code from destination object all fields are mentioned in field set of Destination Object
    public static void updateProductAttributeValueBeforeInsert(List<Apttus_Config2__ProductAttributeValue__c> productAttributeValueNewList) {
        List<String> destinationList=new List<String>();
        Id currentRecordId;
        try
        {
            for (Apttus_Config2__ProductAttributeValue__c productAttributeValueRecord:productAttributeValueNewList) {
                currentRecordId=productAttributeValueRecord.Id;
                System.debug('############################## Destination Code is:'+productAttributeValueRecord.APTS_DestinationCode__c);
                destinationList.add(productAttributeValueRecord.APTS_DestinationCode__c);
            }
            Map<String,Destination__c> destinationMap=DestinationSelector.getDestinationValuesForDestinationCode(destinationList);

            for (Apttus_Config2__ProductAttributeValue__c productAttributeValueRecord:productAttributeValueNewList) {
                currentRecordId=productAttributeValueRecord.Id;
                for (Schema.FieldSetMember f : SObjectType.Destination__c.FieldSets.DestinationFieldSet.getFields()) {
                    if (destinationMap.containsKey(productAttributeValueRecord.APTS_DestinationCode__c)) {
                        System.debug('############################## f.getFieldPath() is:'+f.getFieldPath());
                        productAttributeValueRecord.put(f.getFieldPath(), destinationMap.get(productAttributeValueRecord.APTS_DestinationCode__c).get(f.getFieldPath()));
                    }

                }
            }

        }
        catch(Exception Ex)
        {
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'ProductAttributeValueHelper', 'updateProductAttributeValueBeforeCreation', currentRecordId);
        }

}

    public static void updateStartDateEndDateAndQty(String productAttributevalueId, String cartId, Date startDate, Date endDate, Decimal quantity)
    {
        //List<Id> attributeIdList=new List<Id>();
        //attributeIdList.add(cartId);
        Map<Id, Apttus_Config2__ProductAttributeValue__c> productAttributeValuesMap= ProductAttributevaluesSelector.getProductAttributeValuesById(cartId);
        list<Apttus_Config2__ProductAttributeValue__c> productAttributeValuesToUpdateList = new list<Apttus_Config2__ProductAttributeValue__c>();
        if (!productAttributeValuesMap.isEmpty()) {
            if(productAttributeValuesMap.containsKey(productAttributevalueId)){
                //productAttributeValuesMap.get(productAttributevalueId).APTS_End_Date__c=endDate;
                //productAttributeValuesMap.get(productAttributevalueId).APTS_Start_Date__c=startDate;
                //productAttributeValuesMap.get(productAttributevalueId).Quantity__c=quantity;
                productAttributeValuesToUpdateList.add(new Apttus_Config2__ProductAttributeValue__c(Id = productAttributevalueId, 
                                                                                                   APTS_End_Date__c = endDate, APTS_Start_Date__c = startDate, Quantity__c = quantity));
            }
            for(Apttus_Config2__ProductAttributeValue__c productAttibuteValueRecord : productAttributeValuesMap.values()){
                if(productAttibuteValueRecord.Apttus_Config2__LineItemId__r.Apttus_Config2__OptionId__r.Apttus_Config2__ProductType__c == 'Accommodation'){
                    productAttributeValuesToUpdateList.add(new Apttus_Config2__ProductAttributeValue__c(Id = productAttibuteValueRecord.Id, APTS_Start_Date__c = startDate.addDays(-1), APTS_End_Date__c = endDate.addDays(1)));
                }
            }
        }
        system.debug('==productAttributeValuesToUpdateList=='+productAttributeValuesToUpdateList);
        if(!productAttributeValuesToUpdateList.isEmpty()){
            update productAttributeValuesToUpdateList;
        }
        //SObjectUnitOfWork.executeUpdateProductAttributeValues(productAttributeValuesToUpdateList);
    }

}