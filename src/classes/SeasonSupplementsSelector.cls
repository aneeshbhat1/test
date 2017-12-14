/**************************************************************************************
Apex Class Name    : SeasonSupplementsSelector
Version            : 1.0
Created Date       : September 21 2017
Function           : Season Supplements Selector for queries required records
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/21/2017              Original Version
*******************************************************************************/
public class SeasonSupplementsSelector {


    /*
    Description : Helper Method to select season supplement records depending on course dates and product code
    Created by : Mitul Parmar
    Created Date : 21-Sep-2017
    */
    public static List<Season_Supplements__c> getSeasonSupplementFromCourseDate(Date courseStartDate, Date courseEndDate, String productCode, String market) {

        List<Season_Supplements__c> seasonSupplemetList = new List<Season_Supplements__c>();
        system.debug('Market code is' +market);
        system.debug('Region  is' +productCode);
        if (courseStartDate != null && courseEndDate != null && !string.isBlank(productCode)) {
            seasonSupplemetList = [
                    select Id, SupplementEndDate__c, SupplementStartDate__c, IsMainSupplement__c, SeasonSupplementProduct__c, SeasonSupplementProduct__r.Name, SeasonSupplementProduct__r.Apttus_Config2__ConfigurationType__c
                    from Season_Supplements__c
                    where Destination_Location__c = :productCode
                   AND
                    (IsMainSupplement__c = TRUE OR APTS_Market__c =:market )
                    AND
                    (( SupplementStartDate__c  <= :courseStartDate AND SupplementEndDate__c >= :courseStartDate)
                    OR (SupplementStartDate__c <= :courseEndDate AND SupplementEndDate__c >= :courseEndDate)
                    OR (SupplementStartDate__c >= :courseStartDate AND SupplementEndDate__c <= :courseEndDate)
                    )
            ];
        }
        system.debug('seasonSupplemetList count is' +seasonSupplemetList.size());
        return seasonSupplemetList;
    }
}