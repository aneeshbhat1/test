/**************************************************************************************
Apex Class Name    : RankingHandler
Version            : 1.0
Created Date       : June 22 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  06/22/2017              Original Version
*******************************************************************************/
public class RankingHandler {
    public static Map<Id, Integer> calculateRank(List<Lead> leadRecords) {
        Map<id, Integer> rankingMap = new Map<id, Integer>();
        Integer rank = 0;
        for (Lead incomingLead:leadRecords) {
            rank = incomingLead.FirstName.startsWithIgnoreCase(constant.alphabetV)?
                    Integer.valueOf(10):Integer.valueOf(5);
            rankingMap.put(incomingLead.id, rank);
        }
        return rankingMap;

    }

    ///Pass LeadList to check each lead against Ranking setting and legal setting
    public static Map<ID, Boolean> getLeadSettings(List<Lead> leadList) {
        Map<ID, Boolean> qualificationMap = new Map<Id, Boolean>();
        try {
            //get the map of raning name and settings
            Map<String, LeadRankingSetting__c> rankingSettingMap = LeadRankingSetting__c.getAll();
            //get the map of legal setting name and legal setting
            Map<String, LegalSettings__c> MapLegalSetting = LegalSettings__c.getAll();
            Boolean isQualified = false;
            String Combination = constant.blank;
            LegalSettings__c objLS = new LegalSettings__c();
            for (Lead leadRecord : leadList) {
                 //skipping ranking and legal setting if the lead are loading as Account or Opportunity
               
                if(!String.isBlank(leadRecord.CreationType__c) && leadRecord.CreationType__c != Constant.stringLead &&
                        leadRecord.CreationMethod__c == 'Excel Import') {
                    qualificationMap.put(leadRecord.id,true);
                   continue;
                }
                //Ranking
                Combination = leadRecord.Market__c + constant.underScore + leadRecord.Program__c;
                system.debug('******** combination'+Combination);
                if (rankingSettingMap.containsKey(Combination) &&
                        leadRecord.Ranking__c < rankingSettingMap.get(Combination).Ranking__c) {
                    system.debug('******** map'+rankingSettingMap.get(Combination).Ranking__c);
                    isQualified = true;
                }
                // Both Ranking setting and legal setting should be true to be qualified
                //legal setting
                if (isQualified && MapLegalSetting.containsKey(leadRecord.Market__c)) {
                    objLS = MapLegalSetting.get(leadRecord.Market__c);
                    system.debug('Doubleoptin>>>>>'+objLS);
                    system.debug('Doubleoptin@@@@@'+leadRecord);
                    if (objLS.CallCampaign__c && objLS.DoubleOptIn__c && leadRecord.RequestType__c== constant.CAM) {
                        isQualified = leadRecord.RequestType__c== constant.CAM  && leadRecord.DoubleOptIn__c?true:false;
                    } else if(objLS.CallCampaign__c && leadRecord.RequestType__c== constant.CAM ){
                        isQualified = true;
                    }
                    else if(objLS.DoubleOptIn__c && leadRecord.RequestType__c!= constant.CAM && leadRecord.DoubleOptIn__c){
                        isQualified = true;
                    }
                    else if(!objLS.DoubleOptIn__c && leadRecord.RequestType__c!= constant.CAM) {
                        isQualified=true;
                    }
                    else {
                        isQualified = false;
                    }
                }
                //map of lead and qualified status
                qualificationMap.put(leadRecord.Id, isQualified);
                system.debug('final qualification Map **** Lead record '+leadRecord.Id+'********** value '+isQualified);
            }
        } catch (exception ex) {
            ExceptionHandler.errorLog( ex.getMessage(), ex.getStackTraceString(), 'RankingHandler',
                    'getLeadSettings', '');
        }
        return QualificationMap;
    }
}