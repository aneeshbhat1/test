/**************************************************************************************
Apex Class Name    : ProductAttributeValueDispatcher
Version            : 1.0
Created Date       : September 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/20/2017              Original Version
*******************************************************************************/
public  class ProductAttributeValueDispatcher {

    public static void run() {
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert)
                ProductAttributeValues.onBeforeInsert(trigger.new);
        }
    }
}