/**************************************************************************************
Apex Class Name    : StartDatesSelector
Version            : 1.0
Created Date       : September 22 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/22/2017              Original Version
*******************************************************************************/

public  class StartDatesSelector {

    Public static List<Start_Dates__c> getSatrtDatesForSelectedBundle(String query ){

        return Database.query(query);

    }

    Public static List<ProfileNamesForAdminAccess__mdt> getProfilesForAdminAccess(String sObjectname ){

        return [Select Id,Profiles__c,SObjectname__c from ProfileNamesForAdminAccess__mdt where SObjectname__c=:sObjectname];

    }

    Public static List<StartDateSettings__mdt> getStartdateSettings(String destinationCode){

                List<StartDateSettings__mdt> startDateSettingsList= new List<StartDateSettings__mdt>();
        startDateSettingsList=[Select Id,DestinationCode__c,EndDateOffSet__c,ProductCode__c,ProductSubType__c,ProductType__c,StartDateOffSet__c,ValidAccommodationDays__c from StartDateSettings__mdt where DestinationCode__c=:destinationCode ];
        if (startDateSettingsList.size()==0) {
            startDateSettingsList= [Select Id,DestinationCode__c,EndDateOffSet__c,ProductCode__c,ProductSubType__c,ProductType__c,StartDateOffSet__c,ValidAccommodationDays__c from StartDateSettings__mdt where DestinationCode__c='ALL' ];
        }
        return startDateSettingsList;

    }

}