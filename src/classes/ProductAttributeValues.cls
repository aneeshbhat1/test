/**************************************************************************************
Apex Class Name    : ProductAttributeValues
Version            : 1.0
Created Date       : September 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/20/2017              Original Version
*******************************************************************************/

public  class ProductAttributeValues {
    public static void onBeforeInsert(List<SObject> newItems) {
        ProductAttributeValueHelper.updateProductAttributeValueBeforeInsert(newItems);
    }
}