/**************************************************************************************
Apex Class Name    : SObjectSelector
Version            : 1.0
Created Date       : July 21 2017
Function           : Returns sObjects
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Aneesh B                  07/21/2017              Original Version
 *************************************************************************************/
public with sharing class SObjectSelector {
    public static List<ContentWorkSpace> getTemplateDocuments(String libraryFolder) {
        return [SELECT Id, Name,(Select Id,ContentDocument.Title,ContentDocument.LatestPublishedVersionId,ContentDocument.FileType,ContentDocument.Description From AttachedContentDocuments ORDER By ContentDocument.Title) FROM ContentWorkspace WHERE Name LIKE :libraryFolder];
//        return [SELECT Id, File_Path__c, Help_Text__c, Label FROM Excel_Templates__mdt];
    }
    public static List<CollaborationGroup> getCollaborationGroup(string groupName){
        return [SELECT Id,Name FROM CollaborationGroup WHERE Name LIKE :groupName];
    }

    public static List<ContentDocument> getDocument(Id Id){
        return [SELECT Id,LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId = :Id];
    }
}