/**************************************************************************************
Apex Class Name    : OpportunityHelper
Version            : 1.0
Created Date       : Apr 25 2017
Function           : Opportunity related business logic here.
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  04/25/2017              Original Version
 *************************************************************************************/

public class OpportunitiesHelper {

//For after insert
    public static void createShareOnInsert(List<Opportunity> oppList) {

        Map<Id, String> OpportunityMap = new Map<Id, String>();

        for (Opportunity opp : oppList) {
            OpportunityMap.put(opp.ID, opp.RecordSharingKey__c); //*** replace name with the Formula field
        }

        //get the public group details here
        Map<String, ID> publicGroupMap = publicGroupsSelector.getPublicGroups(OpportunityMap.values());

        List<OpportunityShare> OppShareList = new List<OpportunityShare>();
        OppShareList = createOpportunityShareRec(OpportunityMap, publicGroupMap);
        try {
            if (OppShareList.size() > 0) {
                insert OppShareList;
            }
        } Catch (Exception ex) {

        }
    }

    public static List<opportunityShare> createOpportunityShareRec(Map<Id, String> opportunityMap, Map<String, ID> publicGroupMap) {
        List<opportunityShare> opportunityShareList = new List<opportunityShare>();
        for (ID LId : opportunityMap.keyset()) {

            if (publicGroupMap.containskey(opportunityMap.get(LId))) {
                opportunityShare shareRecord = createShareRecord(LId, publicGroupMap.get(opportunityMap.get(LId)), System.Label.EditAccessLevel);
                opportunityShareList.add(shareRecord);
            }

        }
        return opportunityShareList;
    }


//For after update
    public static void createShareOnUpdateTypes(List<opportunity> opportunityNewList, List<opportunity> opportunityOldList) {
        List<String> addPublicGroupNameList = new List<String>();
        List<String> removePublicGroupNameList = new List<String>();
        List<String> allPublicGroupList = new List<String>();
        List<Id> opportunityIdList = new List<Id>();

        for (Integer index = 0; index < opportunityNewList.size(); index++) {
            opportunityIdList.add(opportunityNewList[index].id);
            if (opportunityNewList[index].RecordSharingKey__c != opportunityOldList[index].RecordSharingKey__c) {
                addPublicGroupNameList.add(opportunityNewList[index].RecordSharingKey__c);
                removePublicGroupNameList.add(opportunityOldList[index].RecordSharingKey__c);
            }
            if (opportunityNewList[index].OwnerId != opportunityOldList[index].OwnerId) {
                addPublicGroupNameList.add(opportunityNewList[index].RecordSharingKey__c);
            }
        }
        allPublicGroupList.addAll(addPublicGroupNameList);
        allPublicGroupList.addAll(removePublicGroupNameList);
        Map<String, ID> publicGroupMap = publicGroupsSelector.getPublicGroups(allPublicGroupList);
        //access level
        List<opportunityShare> opportunityShareList = new List<opportunityShare>();
        List<opportunityShare> deleteAccess = new List<opportunityShare>();
        //share table query
        List<opportunityShare> opportunityShareIdList = [select id,userOrGroupId,opportunityId from opportunityShare Where opportunityId in :opportunityIdList];
        Map<String, opportunityShare> opportunityShareIdKeyMap = new Map<String, opportunityShare>();
        Map<Id, Id> groupIdMap = new Map<Id, Id>();
        String opportunityGroupIdCombinatinMap = '';
        for (opportunityShare share : opportunityShareIdList) {
            opportunityGroupIdCombinatinMap = String.valueOf(String.valueOf(share.userOrGroupId) + String.valueOf(share.opportunityid));
            opportunityShareIdKeyMap.put(opportunityGroupIdCombinatinMap, share);
        }

        for (Integer index = 0; index < opportunityNewList.size(); index++) {
            if (opportunityNewList[index].RecordSharingKey__c != opportunityOldList[index].RecordSharingKey__c) {
                if (publicGroupMap.containsKey(opportunityNewList[index].RecordSharingKey__c)) {
                    //add acccess level
                    opportunityshareList.add(createShareRecord(opportunityNewList[index].id, publicGroupMap.get(opportunityNewList[index].RecordSharingKey__c), 'Edit'));
                }
                if (publicGroupMap.containsKey(opportunityOldList[index].RecordSharingKey__c)) {
                    String groupstr = String.valueOf(publicGroupMap.get(opportunityOldList[index].RecordSharingKey__c));
                    groupstr += opportunityNewList[index].id;
                    if (opportunityShareIdKeyMap.containsKey(groupstr)) {
                        deleteAccess.add(opportunityShareIdKeyMap.get(groupstr));
                    }
                }
            }
            if (opportunityNewList[index].OwnerId != opportunityOldList[index].OwnerId) {
                if (publicGroupMap.containsKey(opportunityNewList[index].RecordSharingKey__c)) {
                    opportunityshareList.add(createShareRecord(opportunityNewList[index].id, publicGroupMap.get(opportunityNewList[index].RecordSharingKey__c), 'Edit'));
                }
            }
        }
        if (deleteAccess != null && deleteAccess.size() > 0) {
            delete deleteAccess;
        }
        if (opportunityshareList != null && opportunityshareList.size() > 0) {
            insert opportunityShareList;
        }

    }
    //*********opportunity Share code End here****************//

    public static OpportunityShare createShareRecord(ID recordId, ID userOrGroupId, String accessLevel) {
        OpportunityShare os = new OpportunityShare();
        os.OpportunityId = recordId;
        os.UserOrGroupId = userOrGroupId;
        os.OpportunityAccessLevel = accessLevel;
        return os;
    }

    public static void UpdateMarketCodeOnAccount(List<Opportunity> oppNewList, List<Opportunity> oppOldList) {
        Map<Id, String> accountmarketCodeMap = new Map<Id, String>();
        for (Integer i = 0; i < oppNewList.size(); i++) {

            if (oppNewList[i].Market__c != oppOldList[i].Market__c) {
                accountmarketCodeMap.put(oppNewList[i].AccountID, oppNewList[i].Market__c);
            }
        }

        List<ID> accIDList = new List<ID>(accountmarketCodeMap.keyset());

        List<Account> accList = OpportunitiesSelector.getAccountDetails(accIDList);
        for (Account acc : accList) {
            if (accountmarketCodeMap.containskey(acc.ID)) {
                acc.Market__c = accountmarketCodeMap.get(acc.ID);
            }
        }
        update accList;
    }


    /**
    * @author Arkadiusz Celej
    * ver 1.0 8-Dec-2017
    * @description This method sets Letter and Label for opportunities based on matching TemplateSettings records
    *
    * */
    public static void setDefaultLetterAndLabel(List<Opportunity> opportunities) {
        System.debug('Letter Label setting');
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            accountIds.add(opp.AccountId);
        }
        accountIds.remove(NULL);
        Map<Id, Account> opportunityAccounts = new Map<Id, Account>(AccountsSelector.getAllAccountOnId(new List<Id>(accountIds)));
        Map<String, TemplateSetting__c[]> templateSettings = getTemplateSettingsForOpportunities(opportunities, opportunityAccounts);

        for (Opportunity opp : opportunities) {

            if (!opportunityAccounts.containsKey(opp.AccountId) || (opp.Letter__c != NULL && opp.Label__c != NULL)) {
                continue;
            }

            Account opportunityAccount = opportunityAccounts.get(opp.AccountId);
            String[] templateKeyParams = new String[]{opp.Market__c, opp.Program__c, opportunityAccount.Language__c};
            String templateKey = generateTemplaterKey(templateKeyParams);
            TemplateSetting__c matchingTemplate = findMatchingTemplateSetting(templateKey, opportunityAccount.Age__c, templateSettings);

            if (matchingTemplate != NULL) {
                if (opp.Letter__c == NULL) {
                    opp.Letter__c = matchingTemplate.Letter__c;
                }
                if (opp.Label__c == NULL) {
                    opp.Label__c = matchingTemplate.Label__c;
                }
            }
        }
    }

    private static TemplateSetting__c findMatchingTemplateSetting(String templateKey, Decimal age, Map<String, TemplateSetting__c[]> templateSettings) {
        if (templateSettings.containsKey(templateKey)) {
            for (TemplateSetting__c templateSetting : templateSettings.get(templateKey)) {
                if (templateSetting.AgeFromYears__c <= age && age <= templateSetting.AgeToYears__c) {
                    return templateSetting;
                }
            }
        }
        return null;
    }

    private static Map<String, TemplateSetting__c[]> getTemplateSettingsForOpportunities(Opportunity[] opportunities, Map<Id, Account> opportunityAccounts) {

        Set<String> markets = new Set<String>();
        Set<String> programs = new Set<String>();
        Set<String> languages = new Set<String>();

        for (Opportunity opp : opportunities) {
            if (opp.Letter__c == NULL || opp.Label__c == NULL) {
                markets.add(opp.Market__c);
                programs.add(opp.Program__c);
                if (opportunityAccounts.containsKey(opp.AccountId)) {
                    languages.add(opportunityAccounts.get(opp.AccountId).Language__c);
                }
            }
        }
        Map<String, TemplateSetting__c[]> result = new Map<String, TemplateSetting__c[]>();
        List<TemplateSetting__c> templateSettings = TemplateSettingsSelector.getTemplateSettings(markets, programs, languages);

        for (TemplateSetting__c template : templateSettings) {
            String[] templateKeyParams = new String[]{template.Market__c, template.Program__c, template.Language__c};
            String key = generateTemplaterKey(templateKeyParams);

            if (!result.containsKey(key)) {
                result.put(key, new List<TemplateSetting__c>());
            }
            result.get(key).add(template);
        }
        return result;
    }

    private static String generateTemplaterKey(List<String> keyParams){
        return String.join(keyParams, '-');
    }
}