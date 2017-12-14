/**************************************************************************************
Apex Class Name    : ProductAttributeValueTrigger
Version            : 1.0
Created Date       : September 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/20/2017              Original Version
*******************************************************************************/

trigger ProductAttributeValueTrigger on Apttus_Config2__ProductAttributeValue__c (before insert,before update,after update,after insert,after delete ,before delete,after undelete ) {

    ProductAttributeValueDispatcher.run();
}