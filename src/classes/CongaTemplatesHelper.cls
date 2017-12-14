/**
 * Created by thejasvi.a on 9/20/2017.
 */

public with sharing class CongaTemplatesHelper {
    public static void createShareOnInsert(List<APXTConga4__Conga_Template__c> tempplateList) {
        try {
            Map<Id, String> TemplateMap = new Map<Id, String>();
            for (APXTConga4__Conga_Template__c templateRec: tempplateList) {
                TemplateMap.put(templateRec.ID, templateRec.RecordSharingKey__c);
            }
            //get the public group details here
            Map<String, Id> publicGroupMap = publicGroupsSelector.getPublicGroups(TemplateMap.values());
            List<APXTConga4__Conga_Template__share> templateShareList = new List<APXTConga4__Conga_Template__share>();
            templateShareList = createTemplateShareRec(TemplateMap, publicGroupMap);
            if (templateShareList.size() > 0) {
                insert templateShareList;
            }
        } Catch (Exception ex) {
            String errMessage = ex.getMessage();
            String trace = ex.getStackTraceString();
            String className = 'CongaTemplatesHelper';
            String methodName = 'createShareOnInsert';
            Id id = '';
            ExceptionHandler.errorLog(errMessage, trace, className, methodName, id);
        }
    }

    public static List<APXTConga4__Conga_Template__share> createTemplateShareRec(Map<Id, String> TemplateMap, Map<String, ID> publicGroupMap) {
        List<APXTConga4__Conga_Template__share> templateShareList = new List<APXTConga4__Conga_Template__share>();
        for (ID LId:TemplateMap.keyset()) {

            if (publicGroupMap.containskey(TemplateMap.get(LId))) {
                APXTConga4__Conga_Template__share shareRecord = createShareRecord(LId, publicGroupMap.get(TemplateMap.get(LId)), System.Label.EditAccessLevel);
                templateShareList.add(shareRecord);
            }

        }
        return templateShareList;
    }

    public static APXTConga4__Conga_Template__share createShareRecord(ID recordId, ID userOrGroupId, String accessLevel) {
        APXTConga4__Conga_Template__share shareRecord = new APXTConga4__Conga_Template__share();
        shareRecord.parentid = recordId;
        shareRecord.UserOrGroupId = userOrGroupId;
        shareRecord.AccessLevel = accessLevel;
        return shareRecord;
    }

    //For after update
    public static void createShareOnUpdateTypes(List<APXTConga4__Conga_Template__c> congaTemplateNewList, List<APXTConga4__Conga_Template__c> congaTemplatedOldList) {
        List<String> addPublicGroupNameList = new List<String>();
        List<String> removePublicGroupNameList = new List<String>();
        List<String> allPublicGroupList = new List<String>();
        List<Id> templateIdList = new List<Id>();

        for (Integer index = 0; index < congaTemplateNewList.size(); index++) {
            templateIdList.add(congaTemplateNewList[index].id);
            if (congaTemplateNewList[index].RecordSharingKey__c != congaTemplatedOldList[index].RecordSharingKey__c) {
                addPublicGroupNameList.add(congaTemplateNewList[index].RecordSharingKey__c);
                removePublicGroupNameList.add(congaTemplatedOldList[index].RecordSharingKey__c);
            }
            if (congaTemplateNewList[index].OwnerId != congaTemplatedOldList[index].OwnerId) {
                addPublicGroupNameList.add(congaTemplateNewList[index].RecordSharingKey__c);
            }
        }
        allPublicGroupList.addAll(addPublicGroupNameList);
        allPublicGroupList.addAll(removePublicGroupNameList);
        Map<String, ID> publicGroupMap = publicGroupsSelector.getPublicGroups(allPublicGroupList);
        //access level
        List<APXTConga4__Conga_Template__share> templateShareList = new List<APXTConga4__Conga_Template__share>();
        List<APXTConga4__Conga_Template__share> templatedeleteAccess = new List<APXTConga4__Conga_Template__share>();
        //share table query
        List<APXTConga4__Conga_Template__share> templatedShareIdList = [select id,userOrGroupId,parentid from APXTConga4__Conga_Template__share  Where parentid  in :templateIdList];
        Map<String, APXTConga4__Conga_Template__share> templateShareIdKeyMap = new Map<String, APXTConga4__Conga_Template__share>();
        Map<Id, Id> groupIdMap = new Map<Id, Id>();
        String templateGroupIdCombinatinMap = '';
        for (APXTConga4__Conga_Template__share share : templatedShareIdList) {
            templateGroupIdCombinatinMap = String.valueOf(String.valueOf(share.userOrGroupId) + String.valueOf(share.parentid));
            templateShareIdKeyMap.put(templateGroupIdCombinatinMap, share);
        }

        for (Integer index = 0; index < congaTemplateNewList.size(); index++) {
            if (congaTemplateNewList[index].RecordSharingKey__c != congaTemplatedOldList[index].RecordSharingKey__c) {
                if (publicGroupMap.containsKey(congaTemplateNewList[index].RecordSharingKey__c)) {
                    //add acccess level
                    templateShareList.add(createShareRecord(congaTemplateNewList[index].id, publicGroupMap.get(congaTemplateNewList[index].RecordSharingKey__c), 'Edit'));
                }
                if (publicGroupMap.containsKey(congaTemplatedOldList[index].RecordSharingKey__c)) {
                    String groupstr = String.valueOf(publicGroupMap.get(congaTemplatedOldList[index].RecordSharingKey__c));
                    groupstr += congaTemplateNewList[index].id;
                    if (templateShareIdKeyMap.containsKey(groupstr)) {
                        templatedeleteAccess.add(templateShareIdKeyMap.get(groupstr));
                    }
                }
            }
            if (congaTemplateNewList[index].OwnerId != congaTemplatedOldList[index].OwnerId) {
                if (publicGroupMap.containsKey(congaTemplateNewList[index].RecordSharingKey__c)) {
                    templateShareList.add(createShareRecord(congaTemplateNewList[index].id, publicGroupMap.get(congaTemplateNewList[index].RecordSharingKey__c), 'Edit'));
                }
            }
        }
        if (templatedeleteAccess != null && templatedeleteAccess.size() > 0) {
            delete templatedeleteAccess;
        }
        if (templateShareList != null && templateShareList.size() > 0) {
            system.debug('records inserted'+templateShareList);
            insert templateShareList;
            system.debug('records after inserted'+templateShareList);
        }

    }

}