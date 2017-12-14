/**************************************************************************************
Apex Class Name    : DestinationSelector
Version            : 1.0
Created Date       : September 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/20/2017              Original Version
*******************************************************************************/

public  class DestinationSelector {

    public static Map<String,Destination__c> getDestinationValuesForDestinationCode(List<String> destinationCodes)
    {
                Map<String,Destination__c> destinationMap=new  Map<String,Destination__c>();
        for(Destination__c destinationRecord:[Select Id,Name,Country__c,DestinationCode__c,Language__c from Destination__c where DestinationCode__c in:destinationCodes])
        {
            destinationMap.put(destinationRecord.DestinationCode__c,destinationRecord);
        }
        System.debug('############################## destinationMap is count is:'+destinationMap.size());
        return destinationMap;
    }
}